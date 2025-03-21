class ClassMeetingAttribute < ApplicationRecord
    belongs_to :class_attribute
    validates :class_attribute, presence: true
    validate :validate_datetime_fields
    validate :validate_date_fields

  private

  def validate_datetime_fields
    [:start_time, :end_time].each do |field|
      errors.add(field, 'must be a DateTime') unless send(field).is_a?(DateTime)
    end
  end

  def validate_date_fields
    [:start_date, :end_date].each do |field|
      errors.add(field, 'must be a Date') unless send(field).is_a?(Date)
    end
  end
end
  