class AddNullPropertyToTranscriptCourses < ActiveRecord::Migration[7.2]
  def change
    change_column_null(:transcript_courses, :student_id, false)
    change_column_null(:transcript_courses, :course_id, false)
    change_column_null(:transcript_courses, :grade, false)
    change_column_null(:transcript_courses, :semester, false)
    change_column_null(:transcript_courses, :year, false)
  end
end
