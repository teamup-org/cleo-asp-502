# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClassAttribute, type: :model do
    context 'When creating a valid class attribute' do
        it 'is valid with valid attributes' do
          course = Course.find_or_create_by!(ccode: "EGOB", cnumber:"248")
          class_attribute = ClassAttribute.create(crn: 56508,course: course)
          expect(class_attribute).to be_valid
        end
    end

    context 'When creating an invalid class attribute' do
        it 'is invalid with missing attributes' do
          invalid_class_attribute = ClassAttribute.create(crn: 56508)
          expect(invalid_class_attribute).to be_invalid
        end
    end

    context 'When creating a duplicate class attribute' do
        it 'is invalid with duplicate crn' do
            course = Course.find_or_create_by!(ccode: "EGOB", cnumber:"248")
          valid_class_attribute = ClassAttribute.create(crn: 56534,course:course)
          invalid_class_attribute2 = ClassAttribute.create(crn: 56534,course:course)
          expect(invalid_class_attribute2).to be_invalid
        end
    end
    
end
