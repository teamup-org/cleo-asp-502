class ScheduleController < ApplicationController
def index
  color_map_1 = {index => 0, total => 0, colors = []}
  /
  🔴❤️🍓🍉🍎🍒
  🟠🔥🟡✨☀️🔆
  🔵🌀🟢🍀💎🌊
  🟣🍇🟤🏈⚫🎱
  🩷🌷🤍🦢🦋🌈
  🎄🎁🎺🎷🐋🐬
  🐔🥚🧑👶🪴🌱
  / 
  if params[:student_id].present?
        @student = Student.find(params[:student_id])
        @student_courses = @student.student_courses
      else
        @student_courses = StudentCourse.none
    end
    if params[:semester_num].present?
      @semester_courses = StudentCourse.where(sem: params[:semester_num]).to_a 
      @loaded_classes = {}
      @semester_courses.each do |studentCourse|
        puts "HELLLO  #{studentCourse.course_id}\n\n"
        course = studentCourse.course
        @loaded_classes[course] = []
        classes = ClassAttribute.where(course_id: course.id).to_a
        classes.each do |klass|
          puts "HELLLO  "
          @loaded_classes[course].push(klass)
        end
      end
    end
end
end
