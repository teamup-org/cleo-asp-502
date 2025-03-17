require 'rails_helper'

RSpec.describe CourseFinder, type: :service do
  let!(:valid_course) { Course.create!(ccode: 'CSCE', cnumber: '121', credit_hours: 3) }
  let!(:invalid_course) { Course.create!(ccode: 'NONE', cnumber: '999', credit_hours: 0) }

  let(:params_valid) { { ccode: 'CSCE', cnumber: '121', credit_hours: '3' } }
  let(:params_invalid) { { ccode: 'NONE', cnumber: '998', credit_hours: '0' } }

  describe '#call' do
    it 'applies filters correctly with valid params' do
      result = CourseFinder.call(params_valid)
      expect(result).to be_an(ActiveRecord::Relation)
      expect(result.count).to be > 0
      expect(result.first.ccode).to eq('CSCE')
    end

    it 'applies filters correctly with invalid params' do
      result = CourseFinder.call(params_invalid)
      expect(result).to be_an(ActiveRecord::Relation)
      expect(result.count).to be 0
    end
  end
end
