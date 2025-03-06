class AddCourseDescriptions < ActiveRecord::Migration[7.2]
  require 'csv'
  
  def up

    unless column_exists?(:courses, :description)
      add_column :courses, :description, :text
    end

    course_descriptions_1 = Rails.root.join('lib', 'data','newData','csv', 'DescriptionData1.csv')
    course_descriptions_2 = Rails.root.join('lib', 'data','newData','csv', 'DescriptionData2.csv')
    update_description(course_descriptions_1)
    update_description(course_descriptions_2)
  end
  def down
    if column_exists?(:courses, :description)
      remove_column :courses, :description
    end
  end
  def update_description(path)
    CSV.foreach(path, headers: true) do |row|
      cnumber = row['cnumber']
      ccode = row['ccode']
      description = row['description']
      
      next if cnumber.blank? || ccode.blank? || description.blank?
      
      course = Course.find_by(cnumber: cnumber, ccode: ccode)
      
      if course
        course.update(description: description)
      else
        puts "Course not found: #{cnumber} - #{ccode}"
      end
    end
  end
end
