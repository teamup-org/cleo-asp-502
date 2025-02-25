class TranscriptCoursesController < ApplicationController
  before_action :set_transcript_course, only: %i[ show edit update destroy ]

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
        format.html { redirect_to @transcript_course, notice: "Transcript course was successfully created." }
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
        format.html { redirect_to @transcript_course, notice: "Transcript course was successfully updated." }
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
      format.html { redirect_to transcript_courses_path, status: :see_other, notice: "Transcript course was successfully destroyed." }
      format.json { head :no_content }
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
end
