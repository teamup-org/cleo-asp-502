# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClassMeetingAttribute, type: :model do
  class_attribute = ClassAttribute.find_or_create_by(crn: 56508,course: course)  
    context 'When creating a valid class meeting attribute' do
        it 'is valid with valid attributes' do
          course = Course.find_or_create_by!(ccode: "EGOB", cnumber:"248")
          class_attribute = ClassAttribute.create(crn: 56508,course: course)  
          class_meeting_attribute = ClassMeetingAttribute.create(class_attribute: class_attribute)
          expect(class_meeting_attribute).to be_valid
        end
    end

    context 'When creating an invalid class meeting attribute' do
        it 'is invalid with missing attributes' do
          invalid_class_meeting_attribute = ClassMeetingAttribute.create!()
          expect(invalid_class_meeting_attribute).to be_invalid
        end
    end
    subject { class_meeting_attribute.new(start_time: start_time, end_time: end_time, start_date: start_date, end_date: end_date, class_attribute: class_attribute) }
    let(:valid_datetime) { DateTime.now }
    let(:valid_date) { Date.today }

    context 'with valid attributes' do
      let(:start_time) { valid_datetime }
      let(:end_time) { valid_datetime }
      let(:start_date) { valid_date }
      let(:end_date) { valid_date }

      it 'is valid with correct types' do
        expect(subject).to be_valid
      end
  end
  context 'with invalid start_time and end_time' do
    let(:start_time) { 'invalid datetime' }
    let(:end_time) { 12345 }
    let(:start_date) { valid_date }
    let(:end_date) { valid_date }

    it 'is not valid' do
      expect(subject).not_to be_valid
      expect(subject.errors[:start_time]).to include('must be a DateTime')
      expect(subject.errors[:end_time]).to include('must be a DateTime')
    end
  end

  context 'with invalid start_date and end_date' do
    let(:start_time) { valid_datetime }
    let(:end_time) { valid_datetime }
    let(:start_date) { 'invalid date' }
    let(:end_date) { 98765 }

    it 'is not valid' do
      expect(subject).not_to be_valid
      expect(subject.errors[:start_date]).to include('must be a Date')
      expect(subject.errors[:end_date]).to include('must be a Date')
    end
  end
end
