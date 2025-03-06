class CreateTranscriptCourses < ActiveRecord::Migration[7.2]
  def change
    create_table :transcript_courses do |t|
      t.string :student_id
      t.bigint :course_id
      t.string :grade
      t.integer :semester
      t.integer :year

      t.timestamps
    end
  end
end
