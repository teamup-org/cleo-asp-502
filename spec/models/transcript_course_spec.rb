require 'rails_helper'

RSpec.describe TranscriptCourse, type: :transcript_courses do
  include_context 'models setup'

  context 'When creating a valid transcript course' do
    it 'is valid with valid attributes' do
      expect(transcript_course).to be_valid
    end
  end

  context 'When creating an invalid transcript course' do
    it 'is invalid with missing attributes' do
      invalid_transcript_course = TranscriptCourse.create(student:)
      expect(invalid_transcript_course).to be_invalid
    end
  end

  context 'When creating a duplicate transcript course' do
    it 'is invalid with duplicate course_id, student_id' do
      dup_transcript_course = TranscriptCourse.new(
        student: transcript_course.student,
        course: transcript_course.course,
        semester: transcript_course.semester,
        grade: transcript_course.grade,
        year: transcript_course.year
      )
      expect(dup_transcript_course).to be_invalid
    end
  end

  context 'When creating two student course' do
    it 'is valid with unique course_id, student_id' do
      course = Course.create(ccode: 'CSCE', cnumber: 435, cname: 'Parallel Computing', credit_hours: 3)
      unique_transcript_course = TranscriptCourse.create(student: transcript_course.student, course:, semester: 1,
                                                         year: 2021, grade: 'A')
      expect(unique_transcript_course).to be_valid
    end
  end
end
