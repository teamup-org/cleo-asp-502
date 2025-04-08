# frozen_string_literal: true

class DegreePlannerController < ApplicationController
  before_action :set_student
  skip_before_action :authenticate_student_login! if Rails.env.test?

  EXPECTED_HEADERS = ['Course ID', 'Course Code', 'Course Number', 'Course Name', 'Credits', 'Semester'].freeze

  def show
    @default_plan = DegreeRequirement.includes(:course).where(major: @student.major)
    @student_courses = StudentCourse.includes(:course).where(student: @student).order(:sem)
    @course_prerequisite_status = check_prerequisites(@student, @student_courses)
    
    # Calculate earliest semester for each course
    @earliest_semesters = {}
    @student_courses.each do |student_course|
      @earliest_semesters[student_course.course.id] = earliest_semester_for_course(@student, student_course.course)
    end

    # Calculate tooltip content for each course
    @tooltip_contents = {}
    @course_prerequisite_status.each do |course_status|
      student_course = course_status[:student_course]
      @tooltip_contents[student_course.course.id] = tooltip_content(student_course, course_status)
    end
    
    @emphasis_options = Emphasis.all.pluck(:ename)
    @track_options = Track.all.pluck(:tname)
    finder_param = search_params
    finder_param[:student] = @student.id
    @courses = CourseFinder.transcript_call(finder_param)
  end

  def index
    courses = CourseFinder.call(search_params)
    render json: courses
  end

  def add_course
    @student_course = StudentCourse.new(student_id: current_student.id, course_id: params[:course_id],
                                        sem: params[:sem])

    if @student_course.save
      flash[:success] = 'Course added successfully!'
      redirect_to degree_planner_path
    else
      flash[:error] = 'Error adding course.'
      render :show
    end
  end

  def clear_courses
    destroy_student_courses

    flash[:success] = 'All courses have been removed successfully!'
    redirect_to student_degree_planner_path(@student)
  end

  def set_default
    destroy_student_courses

    degree_requirements = DegreeRequirement.where(major_id: @student.major_id)
    add_student_course_records(degree_requirements)

    flash[:success] = 'Degree planner has been filled with courses from your major!'
    redirect_to student_degree_planner_path(@student)
  end

  def update_plan
    selected_course_id = params[:add_course].to_i
    semester = params[:sem].to_i

    if selected_course_id.positive? && semester.between?(1, 8)
      student_course = StudentCourse.new(student_id: @student.id, course_id: selected_course_id, sem: semester)

      if student_course.save
        flash[:success] = 'Course added successfully!'
      else
        flash[:error] = student_course.errors.full_messages.to_sentence
      end
    else
      flash[:error] = "Invalid course ID or semester value: Course ID - #{selected_course_id}, Semester - #{semester}"
    end

    redirect_to student_degree_planner_path(@student)
  end

  def remove_course
    student_course = StudentCourse.find_by(student_id: @student.id, course_id: params[:course_id])

    if student_course
      student_course.destroy
      flash[:success] = 'Course removed successfully!'
    else
      flash[:error] = 'Course not found in your planner.'
    end

    respond_to do |format|
      format.html { redirect_to student_degree_planner_path(@student) }
      format.json { head :no_content }
      format.js
    end
  end

  # In DegreePlannerController
  def generate_custom_plan
    planner_service = DegreePlannerService.new(@student, params[:interests][:emphasis_area],
                                               params[:interests][:track_area])
    planned_courses = planner_service.generate_plan

    # Clear existing courses
    destroy_student_courses

    # Create new student course records
    planned_courses.each do |course_info|
      StudentCourse.create!(
        student: @student,
        course_id: course_info[:course_id],
        sem: course_info[:sem]
      )
    end

    flash[:success] = 'Degree plan generated successfully!'
    redirect_to student_degree_planner_path(@student)
  end

  def download_plan
    @student_courses = StudentCourse.where(student_id: @student.id).order(:sem)

    # Generate the CSV data
    csv_data = CSV.generate(headers: true) do |csv|
      csv << EXPECTED_HEADERS

      # Add each record as a row in the CSV, not all are necessary for uploading
      @student_courses.each do |student_course|
        csv << [
          student_course.course.id,
          student_course.course.ccode,
          student_course.course.cnumber,
          student_course.course.cname,
          student_course.course.credit_hours,
          student_course.sem
        ]
      end
    end

    # Send the CSV file to the browser
    send_data csv_data, filename: "degree_plan_#{@student.id}.csv"
  end

  def upload_plan
    if params[:file].present?
      process_csv(params[:file])
    else
      flash[:error] = 'Please upload a CSV file.'
      redirect_to student_degree_planner_path(@student)
    end
  end

  def view_template
    file_path = Rails.root.join('public', 'templates', 'upload_plan_template.csv')
    csv_content = File.read(file_path)
    render plain: csv_content, content_type: 'text/plain'
  end

  private

  def set_student
    @student = Student.find(current_student_login.uid)
    return if @student

    redirect_to some_error_path, alert: 'Student not found.'
  end

  def search_params
    params.permit(:search, :ccode, :cnumber, :credit_hours, :sort_by, :direction)
  end

  def generate_plan_based_on_interests(interests); end

  # Takes records and iteratively adds to student courses
  def add_student_course_records(records)
    records.map do |record|
      StudentCourse.create(student: @student, course_id: record.course_id, sem: record.sem)
    end
  end

  def destroy_student_courses
    @student.student_courses.destroy_all
  end

  def check_prerequisites(student, courses)
    courses_added = student.student_courses.includes(:course)
    courses_by_semester = courses_added.group_by(&:sem)
  
    courses.map do |student_course|
      course = student_course.course
      current_semester = student_course.sem
  
      # Get all courses planned in previous semesters
      previous_courses = courses_by_semester
                         .select { |sem, _| sem < current_semester } # Only semesters before the current one
                         .values
                         .flatten
                         .map(&:course)
  
      # Get prerequisite groups for the current course
      prereq_groups = course.prerequisite_groups
  
      # Initialize arrays to track prerequisite status and missing prerequisites
      prerequisite_status = []
      missing_prereqs = []
  
      prereq_groups.each do |equi_id, prereq_courses|
        # Track the status of each prerequisite in this group
        status = {
          equi_id: equi_id,
          courses: prereq_courses.map do |prereq|
            {
              course: prereq,
              status: if previous_courses.include?(prereq)
                       'taken'
                     elsif courses_added.map(&:course).include?(prereq)
                       'planned'
                     else
                       'not_planned'
                     end
            }
          end
        }
  
        # Count the number of prerequisites that are not planned or not taken
        not_planned_or_not_taken = prereq_courses.count do |prereq|
          !previous_courses.include?(prereq) && !courses_added.map(&:course).include?(prereq)
        end
  
        # If any prerequisites in this group are not planned or not taken, mark as missing
        if not_planned_or_not_taken > 0
          missing_prereqs << {
            equi_id: equi_id,
            courses: prereq_courses
          }
        end
  
        prerequisite_status << status
      end
  
      {
        student_course: student_course,
        prerequisite_status: prerequisite_status,
        prerequisites_met: missing_prereqs.empty?, # Prerequisites are met if no missing prerequisites
        missing_prerequisites: missing_prereqs
      }
    end
  end

  def earliest_semester_for_course(student, course)
    courses_added = student.student_courses.includes(:course)
    courses_by_semester = courses_added.group_by(&:sem)
  
    prereq_groups = course.prerequisite_groups
  
    earliest_semester = 1
  
    prereq_groups.each do |equi_id, prereq_courses|
      prereq_courses.each do |prereq|
        prereq_course_semester = courses_by_semester.find { |sem, courses| courses.map(&:course).include?(prereq) }&.first || 0
        earliest_semester = [earliest_semester, prereq_course_semester + 1].max
      end
    end
  
    earliest_semester
  end

  def tooltip_content(student_course, course_status)
    earliest_semester = earliest_semester_for_course(@student, student_course.course)
    content = "<div class='tooltip-content'>"
    content += "<strong>Earliest Semester:</strong> #{earliest_semester}<br><br>"
    content += "<strong>Prerequisites:</strong><br>"
  
    course_status[:prerequisite_status].each do |group|
      content += "<div class='prerequisite-group'>"
      content += "Need one of:<br>"
      group[:courses].each do |prereq|
        content += "<div class='prerequisite #{prereq[:status]}'>"
        content += "- #{prereq[:course].ccode} #{prereq[:course].cnumber}: #{prereq[:course].cname} (#{prereq[:status]})"
        content += "</div>"
      end
      content += "</div>"
    end
  
    content += "</div>"
    content.html_safe
  end

  # ======== Helper functions for uploading / downloading csv files ========
  def process_csv(file)
    puts 'Reading CSV file...'
    csv_file = read_csv(file)
    puts "CSV file read successfully: #{csv_file.inspect}"

    if valid_csv?(csv_file)
      puts 'CSV file format is valid. Proceeding to import...'
      destroy_student_courses
      import_courses_from_csv(file)
      flash[:success] = 'Degree plan uploaded successfully'
    else
      puts "CSV format validation failed. Headers: #{csv_file.headers}"
      flash[:error] = "CSV format is incorrect. Please ensure the file has headers: #{EXPECTED_HEADERS.join(', ')}."
    end

    redirect_to student_degree_planner_path(@student)
  rescue StandardError => e
    puts "ERROR: #{e.message}"
    puts e.backtrace.join("\n")
    flash[:error] = 'The CSV file is malformed or unreadable. Please upload a valid CSV file.'
    redirect_to student_degree_planner_path(@student)
  end

  def read_csv(file)
    csv_content = File.read(file.path)
    puts "CSV Content: \n#{csv_content}"
    CSV.parse(csv_content, headers: true)
  rescue CSV::MalformedCSVError => e
    puts "CSV Parsing Error: #{e.message}"
    nil
  end

  def valid_csv?(csv_file)
    headers = csv_file.headers.map(&:strip)
    puts "Detected CSV Headers: #{headers}"
    headers == EXPECTED_HEADERS
  end

  def import_courses_from_csv(file)
    CSV.foreach(file.path, headers: true) do |row|
      puts "Processing row: #{row.to_h.inspect}"

      course = Course.find_by(ccode: row['Course Code'], cnumber: row['Course Number'])

      if course.nil?
        puts "Course not found for: #{row['Course Code']} #{row['Course Number']}"
        next
      end

      student_course = StudentCourse.new(
        student: @student,
        course_id: course.id,
        sem: row['Semester']
      )

      if student_course.save
        puts "Saved successfully: #{student_course.inspect}"
      else
        puts "Validation errors: #{student_course.errors.full_messages.join(', ')}"
      end
    end
  end
  # ========================================================================
end
