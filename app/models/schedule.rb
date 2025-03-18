class Schedule < ApplicationRecord
    self.primary_key = :semester, :student_google_id
  
    belongs_to :student, foreign_key: :student_google_id, primary_key: :google_id
    has_many :schedule_classes, foreign_key: [:semester, :student_google_id]
    has_many :class_attributes, through: :schedule_classes
    validates :semester, numericality: { only_integer: true, greater_than: 0 }
    validates :semester, uniqueness: {scope: :student_google_id}
end