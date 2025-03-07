class ClassAttribute < ApplicationRecord
  validates :crn, presence: true, uniqueness: true
  has_many :class_meeting_attributes
  belongs_to :course
end
