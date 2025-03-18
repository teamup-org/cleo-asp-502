class ClassAttribute < ApplicationRecord
  validates :crn, presence: true, uniqueness: true
  has_many :class_meeting_attributes
  has_many :schedule_classes
  has_many :schedules, through: :schedule_classes
  belongs_to :course

  validates :crn, uniqueness: true
  validates :crn, :course, presence: true

end
