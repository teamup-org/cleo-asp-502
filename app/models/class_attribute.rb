class ClassAttribute < ApplicationRecord
  validates :crn, presence: true, uniqueness: true
  has_many :class_meeting_attributes
  has_many :schedules
  belongs_to :course
end
