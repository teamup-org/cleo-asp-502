# frozen_string_literal: true

class ChangeCourseCodeLengthInCourses < ActiveRecord::Migration[7.2]
  def up
    remove_column :courses, :ccode
    add_column :courses, :ccode, :string, limit: 30
  end
  def down
    remove_column :courses, :ccode
    add_column :courses, :ccode, :string, limit: 10
  end
end
