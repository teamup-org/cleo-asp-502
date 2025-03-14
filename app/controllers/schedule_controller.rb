class ScheduleController < ApplicationController
  def create
    schedule_path(semester_num: params[:semester_num], student_id: params[:student_id])
  end
  helper_method :get_emoji

  def get_emoji(c)
    @course_emoji_map[c][:index]+=1
    @course_emoji_map[c][:total]+=1
    colors = @course_emoji_map[c][:colors]
    return colors[@course_emoji_map[c][:index] % colors.size]
  end

  def select_class()
    @selected_class = ClassAttribute.find(params[:class_id])
    @selected_course = @selected_class.course
  end

  def save_class()
    c = ClassAttribute.find(params[:save_id])
    shed = Schedule.find_or_create_by(semester: params[:semester_num], student_google_id: params[:student_id])
    unless shed.schedule_classes.find_by(class_attribute_id:params[:class_id])
      shed.schedule_classes.create(class_attribute_id:params[:class_id])
    end
  end

  def 

  def set_schedule
    @scheduled_classes = {}
    shed = Schedule.find_or_create_by(semester: params[:semester_num], student_google_id: params[:student_id])
    shed.schedule_classes.each do |c|
      @scheduled_classes[c.class_attribute.course] = c.class_attribute
    end
  end
  def check_time_conflict(m1, m2)
    if(m1.sunday && m2.sunday || m1.monday && m2.monday || m1.tuesday && m2.tuesday || m1.wednesday && m2.wednesday || m1.thrusday && m2.thursday || m1.friday && m2.friday || m1.saturday && m2.saturday)
      if m1.start_time < m2.end_time && m1.end_time > m2.start_time
        return true;
      end
  end
  def check_times()
    @loaded_classes.each do |course, classes|
      classes.each do |c, meetings|
        meetings.each do
          if(check_time_conflict(@select_class))
        end
    end
  end
  
def index
  @emoji_maps = [
    {
      index: -1,
      total: -1,
      colors: ["🔴", "❤️", "🍓", "🍉", "🍎", "🍒", "🎺", "🎷"]
    },
    {
      index: -1,
      total: -1,
      colors: ["🟠", "🔥", "🟡", "✨", "☀️", "🔆", "🎄", "🎁"]
    },
    {
      index: -1,
      total: -1,
      colors: ["🔵", "🌀", "🟢", "🍀", "💎", "🌊", "🐋", "🐬"]
    },
    {
      index: -1,
      total: -1,
      colors: ["🟣", "🍇", "🧸", "🧺", "🟤", "🏈", "🎻", "🍫"]
    },
    {
      index: -1,
      total: -1,
      colors: ["🩷", "🌷", "🤍", "🦢", "🦋", "🌈"]
    },
    {
      index: -1,
      total: -1,
      colors: ["🐔", "🥚", "🧑", "👶", "🪴", "🌱"]
    }
  ]
  @selected_class = nil
  @selected_course = nil

  @course_emoji_map = {}
  if params[:class_id].present?
    select_class()
  end
  if params[:save_id].present?
    save_class()
  end
  if params[:student_id].present?
        @student = Student.find(params[:student_id])
        @student_courses = @student.student_courses
      else
        @student_courses = StudentCourse.none
    end
    if params[:semester_num].present?
      set_schedule()
      @semester_courses = StudentCourse.where(sem: params[:semester_num]).to_a 
      @loaded_classes = {}
      @loaded_classes_time_check = {}
      i = 0
      @semester_courses.each do |studentCourse|
        course = studentCourse.course
        @course_emoji_map[course] = @emoji_maps[i % @emoji_maps.size]
        i+=1
        @loaded_classes[course] = {}
        classes = ClassAttribute.where(course_id: course.id).to_a
        classes.each do |klass|
          meetings = ClassMeetingAttribute.where(class_attribute_id: klass.id).to_a
          @loaded_classes[course][klass] = meetings
          @loaded_classes_time_check[course][klass] = false
        end
      end
    end
    check_times()
end
end
