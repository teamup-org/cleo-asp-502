class TranscriptCoursesController < ApplicationController
  before_action :set_student
  before_action :set_transcript_course, only: %i[show edit update destroy]

  EXPECTED_HEADERS = ['Course ID', 'Grade', 'Semester', 'Year'].freeze

  # GET /transcript_courses or /transcript_courses.json
  def index
    @transcript_courses = TranscriptCourse.all
  end

  # GET /transcript_courses/1 or /transcript_courses/1.json
  def show
  end

  # GET /transcript_courses/new
  def new
    @transcript_course = TranscriptCourse.new
  end

  # GET /transcript_courses/1/edit
  def edit
  end

  # POST /transcript_courses or /transcript_courses.json
  def create
    @transcript_course = TranscriptCourse.new(transcript_course_params)

    respond_to do |format|
      if @transcript_course.save
        format.html { redirect_to @transcript_course, notice: 'Transcript course was successfully created.' }
        format.json { render :show, status: :created, location: @transcript_course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @transcript_course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transcript_courses/1 or /transcript_courses/1.json
  def update
    respond_to do |format|
      if @transcript_course.update(transcript_course_params)
        format.html { redirect_to @transcript_course, notice: 'Transcript course was successfully updated.' }
        format.json { render :show, status: :ok, location: @transcript_course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @transcript_course.errors, status: :unprocessable_entity }
      end
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
      new_course = TranscriptCourse.new(
        student: @student,
        course_id: row['Course ID'],
        grade: row['Grade'],
        semester: row['Semester'],
        year: row['Year']
      )
      new_course.save
    end
  end
end
