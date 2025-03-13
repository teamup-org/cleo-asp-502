# frozen_string_literal: true

class DropForeignKeyFromStudentCourses < ActiveRecord::Migration[7.2]
  def up
    remove_foreign_key :student_courses, :students
  end
  def down
  end
end
