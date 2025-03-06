class TranscriptCoursesController < ApplicationController
  before_action :set_student
  before_action :set_transcript_course, only: %i[show edit update destroy]

  skip_before_action :authenticate_student_login! if Rails.env.test?

  EXPECTED_HEADERS = ['Course ID', 'Grade', 'Semester', 'Year'].freeze

  # GET /transcript_courses or /transcript_courses.json
  def index
    if params[:student_id].present?
      @student = Student.find(params[:student_id])
      @transcript_courses = @student.transcript_courses
    else
      @transcript_courses = TranscriptCourse.none
    end

    @students = Student.all
  end

  # GET /transcript_courses/1 or /transcript_courses/1.json
  def show
    @transcript_course = TranscriptCourse.find_by!(student_id: params[:student_id], course_id: params[:course_id])
  end

  # GET /transcript_courses/new
  def new
    @transcript_course = TranscriptCourse.new
  end

  # GET /transcript_courses/1/edit
  def edit
    @transcript_course = set_transcript_course
  end

  # POST /transcript_courses or /transcript_courses.json
  def create
    @transcript_course = TranscriptCourse.new(transcript_course_params)

    if @transcript_course.save
      redirect_to transcript_courses_path(student_id: @transcript_course.student_id, course_id: @transcript_course.course_id),
                  notice: 'Course added successfully.'
    else
      render :new
    end
  end

  # PATCH/PUT /transcript_courses/1 or /transcript_courses/1.json
  def update
    @transcript_course = set_transcript_course
    if @transcript_course.update(transcript_course_params)
      redirect_to transcript_courses_path(student_id: @transcript_course.student_id),
                  notice: 'Course updated successfully.'
    else
      render :edit
    end
  end

  # DELETE /transcript_courses/1 or /transcript_courses/1.json
  def destroy
    @transcript_course.destroy!

    respond_to do |format|
      format.html do
        redirect_to transcript_courses_path, status: :see_other, notice: 'Transcript course was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  def upload_transcript
    if params[:file].present?
      process_csv(params[:file])
    else
      flash[:error] = 'Please upload a CSV file.'
      redirect_to transcript_student_path(current_student_login)
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_transcript_course
    @transcript_course = TranscriptCourse.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def transcript_course_params
    params.require(:transcript_course).permit(:student_id, :course_id, :grade, :semester, :year)
  end

  def destroy_student_transcript
    @student.transcript_courses.destroy_all
  end

  def set_student
    @student = Student.find(current_student_login.uid)
    return if @student

    redirect_to some_error_path, alert: 'Student not found.'
  end

  def process_csv(file)
    csv_file = read_csv(file)

    if valid_csv(csv_file)
      destroy_student_transcript
      import_courses_from_csv(file)
      flash[:success] = 'Transcript uploaded successfully.'
    else
      flash[:error] = "CSV format is incorrect. Please ensure the file has headers: #{EXPECTED_HEADERS.join(', ')}."
    end

    redirect_to transcript_student_path(current_student_login)
  end

  def read_csv(file)
    CSV.read(file.path, headers: true)
  end

  def valid_csv(csv_file)
    (csv_file.headers & EXPECTED_HEADERS).size == EXPECTED_HEADERS.size
  end

  def import_courses_from_csv(csv_file)
    CSV.foreach(csv_file.path, headers: true) do |row|
      TranscriptCourse.create!(
        student: @student,
        course_id: row['Course ID'],
        grade: row['Grade'],
        semester: row['Semester'],
        year: row['Year']
      )
    end
  end
end
