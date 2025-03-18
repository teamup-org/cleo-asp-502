# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScheduleClass, type: :model do
    major = Major.find_or_create_by!(mname: "eters", cname: 'mgkerg')
    student = Student.find_or_create_by!(
        google_id: 12419,
        first_name: 'Jack',
        last_name: 'Adams',
        email: 'JAdams@gmail.com',
        major: major,
        enrol_year: 2020,
        grad_year: 2024,
        enrol_semester: 0,
        grad_semester: 1
      )

        context 'When creating a valid schedule class' do
        it 'is valid with valid attributes' do
            course = Course.find_or_create_by!(ccode: "EKGJ", cnumber:"685")
            class_attribute = ClassAttribute.create(crn: 5986,course:course)
            schedule = Schedule.find_or_create_by!(student:student, semester: 1)
            schedule_class = ScheduleClass.new(schedule: schedule, semester: 1, student_google_id: student.google_id, class_attribute: class_attribute)
            expect(schedule_class).to be_valid
            schedule_class.save!
        end
    end
    context 'When creating a invalid schedule class' do
        it 'is invalid with invalid attributes' do
            course = Course.find_or_create_by!(ccode: "JKEG", cnumber:"364")
            class_attribute = ClassAttribute.create(crn: 8878,course:course)
            schedule_class = ScheduleClass.create(student_google_id:student.google_id,class_attribute: class_attribute)
            expect(schedule_class).to be_invalid
        end
    end
    context 'When creating a invalid schedule class' do
        it 'is invalid with duplicate course' do
            course = Course.find_or_create_by!(ccode: "KJEG", cnumber:"235")
            schedule = Schedule.find_or_create_by(student:student, semester: 1)
            class_attribute = ClassAttribute.create(crn: 56508,course:course)
            class_attribute2 = ClassAttribute.create(crn: 56509,course:course)
            schedule_class = ScheduleClass.create(schedule:schedule,semester: 1, student_google_id:student.google_id,class_attribute: class_attribute)
            schedule_class2 = ScheduleClass.create(schedule:schedule,semester: 1, student_google_id:student.google_id,class_attribute: class_attribute2)
            expect(schedule_class2).to be_invalid
        end
    end
end
