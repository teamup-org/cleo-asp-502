# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Student, type: :model do
  include_context 'models setup'

  let(:student) do
    Student.new(
      google_id: '123456789',
      first_name: 'John',
      last_name: 'Adams',
      email: 'john.adams@example.com',
      enrol_year: 2020,
      grad_year: 2024,
      enrol_semester: 'fall',
      grad_semester: 'spring',
      major: major,
      academic_standing: 'good', # Add valid academic_standing
      preference_online: true    # Add valid preference_online
    )
  end

  context 'When creating a valid student' do
    it 'is valid with valid attributes' do
      expect(student).to be_valid
    end
  end

  context 'When creating an invalid student' do
    it 'is not valid with duplicate google_id' do
      student.save!
      invalid_student = Student.new(
        google_id: student.google_id,
        first_name: 'Jack',
        last_name: 'Adams',
        email: 'JAdams@gmail.com',
        major: student.major,
        enrol_year: 2020,
        grad_year: 2024,
        enrol_semester: 0,
        grad_semester: 1,
        academic_standing: 'good', # Add valid academic_standing
        preference_online: true    # Add valid preference_online
      )
      expect(invalid_student).to be_invalid
    end
  end

  context 'When creating an invalid student' do
    it 'is not valid with missing email' do
      invalid_student = Student.create(
        google_id: '1',
        first_name: 'Jack',
        last_name: 'Adams',
        major: student.major,
        enrol_year: 2020,
        grad_year: 2024,
        enrol_semester: 0,
        grad_semester: 1,
        academic_standing: 'good', # New field
        preference_online: true    # New field
      )
      expect(invalid_student).to be_invalid
    end
  end

  context 'When creating an invalid student' do
    it 'is not valid with non alphanumeric characters in name' do
      invalid_student = Student.create(
        google_id: '1',
        first_name: 'Jack!',
        last_name: 'Adams',
        major: student.major,
        enrol_year: 2020,
        grad_year: 2024,
        enrol_semester: 0,
        grad_semester: 1,
        academic_standing: 'good', # New field
        preference_online: true    # New field
      )
      expect(invalid_student).to be_invalid
    end
  end

  context 'When creating an invalid student' do
    it 'is not valid with enrol_year greater than grad_year' do
      invalid_student = Student.create(
        google_id: '1',
        first_name: 'Jack',
        last_name: 'Adams',
        major: student.major,
        enrol_year: 2024,
        grad_year: 2020,
        enrol_semester: 0,
        grad_semester: 1,
        academic_standing: 'good', # New field
        preference_online: true    # New field
      )
      expect(invalid_student).to be_invalid
    end
  end

  context 'When creating a student with a valid emphasis' do
    it 'is valid' do
      student.update(emphasis_id: emphasis.id)
      expect(student).to be_valid
    end
  end

  context 'When creating a student with a valid track' do
    it 'is valid' do
      student.update(track_id: track.id)
      expect(student).to be_valid
    end
  end

  # New tests for academic_standing and preference_online
  context 'When creating a student with valid academic standing' do
    it 'is valid' do
      student.academic_standing = 'good'
      expect(student).to be_valid
    end
  end

  context 'When creating a student with invalid academic standing' do
    it 'is not valid' do
      expect { student.academic_standing = 'invalid_standing' }.to raise_error(ArgumentError)
    end
  end

  context 'When creating a student with valid preference for online classes' do
    it 'is valid' do
      student.preference_online = true
      expect(student).to be_valid
    end
  end
end
