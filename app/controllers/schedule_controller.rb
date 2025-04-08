class ScheduleController < ApplicationController
  def create
    schedule_path() 
  end
  helper_method :get_emoji

  def get_emoji(course, klass)
    unless course==nil || klass ==nil 
    return @course_class_emoji_map[course][klass];
    end
  end

  def check_time_boolean(meeting1, meeting2)
    if(meeting1.start_time > meeting2.start_time && meeting1.start_time < meeting2.end_time) ||
      (meeting1.end_time > meeting2.start_time && meeting1.end_time < meeting2.end_time) ||
      (meeting2.start_time > meeting1.start_time && meeting2.start_time < meeting1.end_time) ||
      (meeting2.end_time > meeting1.start_time && meeting2.end_time < meeting1.end_time)
        return true;
      end
      return false;
  end
  def check_day_boolean(meeting1, meeting2)
    if (meeting1.sunday && meeting2.sunday || meeting1.monday && meeting2.monday) ||
      (meeting1.tuesday && meeting2.tuesday || meeting1.wednesday && meeting2.wednesday) ||
      (meeting1.thursday && meeting2.thursday || meeting1.friday && meeting2.friday) ||
      (meeting1.saturday && meeting2.saturday)
      return true
    end
    return false
  end
  def check_meeting_time_overlap(meeting1, meeting2)
       return check_day_boolean(meeting1,meeting2) && check_time_boolean(meeting1,meeting2)
  end

  def check_class_array_times(classes, otherClasses, dontAdd=false)
    if !classes || !otherClasses
      return
    end
    classes.each do |sc|
      meetings = ClassMeetingAttribute.where(class_attribute_id: sc.id).to_a
      otherClasses.each do |c|
        otherMeetings = ClassMeetingAttribute.where(class_attribute_id: c.id).to_a
        found = false
        meetings.each do |sm|
          if found
            break
          end
          otherMeetings.each do |m|
            if(check_meeting_time_overlap(sm,m))
              found = true
              unless dontAdd
              @course_class_emoji_map[c.course][c].push(@course_class_emoji_map[sc.course][sc][0].to_s)
              end
              if dontAdd
                return true
              end
            end
          end
        end
      end
    end
    return false
  end

  def selected_classes
    if params[:class_ids]
      select_id = params[:select_class].to_i
      @selected_class_ids = params[:class_ids].split(',').map(&:to_i)
      if @selected_class_ids.include?(select_id)
        @selected_class_ids.delete(select_id)
      else
        @selected_class_ids.push(select_id)
      end
      first = true
      @selected_class_ids.each do |id|
        c = ClassAttribute.find(id)
        if c
          @all_selected_classes.push(c)
          @selected_class_course[c] = c.course
          if first
            @just_selected_class = c
            @just_selected_course = c.course
            first = false
          end
        end
      end
    end
  end

  def save_class
    c = ClassAttribute.find(params[:save_id])
    shed = Schedule.find_or_create_by!(semester: params[:semester_num], student_google_id: params[:student_id])
    scheduled_classes = shed.schedule_classes.joins(:class_attribute).to_a
    if(check_class_array_times([c], scheduled_classes,true))
      flash[:alert] = ("Class cannot be added to schedule. Time conflict with already sceduled class.")
      return
    end
    new_class = shed.schedule_classes.create(class_attribute_id: params[:save_id])
    unless new_class.persisted?
      existing_class = shed.schedule_classes.joins(:class_attribute)
                                            .where(class_attributes: { course_id: c.course_id })
                                            .first
      if existing_class
        existing_class.destroy
        shed.schedule_classes.create!(class_attribute_id: params[:save_id]) 
        flash[:notice] = ("Class already exists in schedule. Removed existing class and added new class.")
      end           
    end
    flash[:notice] = ("Class added to schedule.")
  end

  def remove_class
    shed = Schedule.find_or_create_by!(semester: params[:semester_num], student_google_id: params[:student_id])
    scheduled_class = shed.schedule_classes.find_by(class_attribute_id: params[:save_id])
    if scheduled_class
      scheduled_class.destroy
      return true
    end
    return false
  end

  def set_schedule()
    @scheduled_classes = {}
    shed = Schedule.find_or_create_by!(semester: params[:semester_num], student_google_id: params[:student_id])
    shed.schedule_classes.each do |c|
      @scheduled_classes[c.class_attribute.course] = c.class_attribute
      if !@all_selected_classes.include?(c.class_attribute)
          @all_selected_classes.push(c.class_attribute)
      end
    end
  end
def index
  @emoji_array = 
  [
    [
     "🔴", "❤️", "🍓", "🍉", "🍎", "🍒", "🎺", "🎷"
    ],
    [
      "🟠", "🔥", "🟡", "✨", "☀️", "🔆", "🎄", "🎁"
    ],
    [
      "🔵", "🌀", "🟢", "🍀", "💎", "🌊", "🐋", "🐬"
    ],
    [
      "🟣", "🍇", "🧸", "🧺", "🟤", "🏈", "🎻", "🍫"
    ],
    [
      "🩷", "🌷", "🤍", "🦢", "🦋", "🌈"
    ],
    [
      "🐔", "🥚", "🧑", "👶", "🪴", "🌱"
    ]
  ]
  @selected_class_course = {}
  @selected_class_ids = []
  @course_class_emoji_map = {}
  @all_selected_classes = []
  selected_classes()
  if params[:save_id].present?
    if !remove_class()
      save_class()
    end
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
      i = 0
      @semester_courses.each do |studentCourse|
        course = studentCourse.course
        @course_class_emoji_map[course] = {}
        i+=1
        j = 0
        @loaded_classes[course] = {}
        @all_classes = []
        classes = ClassAttribute.where(course_id: course.id).to_a
        classes.each do |klass|
          @course_class_emoji_map[course][klass] = [@emoji_array[i % @emoji_array.size][j % @emoji_array[i % @emoji_array.size].size]]
          j+=1
          meetings = ClassMeetingAttribute.where(class_attribute_id: klass.id).to_a
          @loaded_classes[course][klass] = meetings
          @all_classes.push(klass)
        end
      end
    end
    check_class_array_times(@all_selected_classes, @all_classes)
  end
end
