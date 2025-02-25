class TranscriptCourse < ApplicationRecord
  belongs_to :student
  belongs_to :course

  validates :student_id, presence: true
  validates :course_id, presence: true
  validates :sem, presence: true
  validates :sem, numericality: { only_integer: true, greater_than: 0 }
  validates :course_id, uniqueness: { scope: :student_id, message: 'has already been added for this student.' }
  validates :grade, presence: true
  validates :year, presence: true
end
