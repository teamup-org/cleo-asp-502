class AddClassTypeToClassAttribute < ActiveRecord::Migration[7.2]
  def up
    ClassAttribute.find_each do |klass|
      meetings = ClassMeetingAttribute.where(class_attribute_id: klass.id).to_a
      foundOnlineLocation = false;
      foundPhysicalLocation = false;
      foundMeetingTime = false;
      foundExamination = false;
      meetings.each do |meet|
         if meet.location == "ONLINE"
            foundOnlineLocation = true
         end
         if meet.location != "ONLINE" && meet.location != ""
            foundPhysicalLocation = true
         end
         if (meet.start_time != nil || meet.end_time != nil) && !(meet.location == "null" && meet.meeting_type == "Examination" )
            foundMeetingTime = true
         end
         if meet.location == "null" && meet.meeting_type == "Examination"
            foundExamination = true
         end
      end
      if !foundMeetingTime && !foundExamination
        klass.update!(class_type: "asyncronous", is_online: true)
      end
      if !foundMeetingTime && foundExamination
        klass.update!(class_type: "asyncronous with exam", is_online: true)
      end
      if foundOnlineLocation && !foundPhysicalLocation && foundMeetingTime
        klass.update!(class_type: "online", is_online: true)

      end
      if foundOnlineLocation && foundPhysicalLocation && foundMeetingTime
        klass.update!(class_type: "hybrid", is_online: false)
      end
      if !foundOnlineLocation && foundPhysicalLocation && foundMeetingTime
        klass.update!(class_type: "in-person", is_online: false)

      end
    end
  end
end
