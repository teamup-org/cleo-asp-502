class ScheduleClass < ApplicationRecord
    belongs_to :schedule, foreign_key: [:semester, :student_google_id]
    belongs_to :class_attribute
  end