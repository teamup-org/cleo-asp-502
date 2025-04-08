# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schedule, type: :model do
  major = Major.find_or_create_by!(mname: 'eters', cname: 'mgkerg')
  student = Student.find_or_create_by!(
    google_id: 12_419,
    first_name: 'Jack',
    last_name: 'Adams',
    email: 'JAdams@gmail.com',
    major:,
    enrol_year: 2020,
    grad_year: 2024,
    enrol_semester: 0,
    grad_semester: 1,
    academic_standing: 'good',
    preference_online: false
  )
  context 'When creating a valid schedule' do
    it 'is valid with valid attributes' do
      schedule = Schedule.create(student:, semester: 1)
      expect(schedule).to be_valid
    end
  end
  context 'When creating a invalid schedule' do
    it 'is invalid with invalid attributes' do
      schedule2 = Schedule.create(student:, semester: 'test')
      expect(schedule2).to be_invalid
    end
  end
  context 'When creating a invalid schedule' do
    it 'is invalid with duplicate semester,student_google_id' do
      schedule2 = Schedule.create(student:, semester: 2)
      schedule3 = Schedule.create(student:, semester: 2)
      expect(schedule3).to be_invalid
    end
  end
end
