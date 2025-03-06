class ClassAttribute < ApplicationRecord
  belongs_to :course
  has_many :class_meeting_attributes
  validates :crn presence :true
  validates :crn uniqueness :true
end
