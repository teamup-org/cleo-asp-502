class AddForeignKeysToTranscriptCourse < ActiveRecord::Migration[7.2]
  def change
    add_foreign_key :transcript_courses, :students, column: :student_id, primary_key: :google_id
    add_foreign_key :transcript_courses, :courses
  end
end
