# frozen_string_literal: true

class Student < ApplicationRecord
  self.primary_key = :google_id

  enum :enrol_semester, %i[fall spring], prefix: :enrol
  enum :grad_semester, %i[fall spring], prefix: :grad

  # Enums for academic standing
  enum academic_standing: {
    good: 'good',
    probation: 'probation',
    dismissed: 'dismissed'
  }

  # Validations
  validates :google_id, presence: true, uniqueness: true, numericality: { only_integer: true }

  # Validations for name
  validates :first_name, :last_name, presence: true, length: { maximum: 255 }
  validates :first_name, :last_name,
            format: { with: /\A[a-zA-Z]+\z/, message: 'only characters are allowed. No whitespaces or punctuations.' }

  # Validations for email
  validates :email, presence: true, length: { maximum: 255 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  # Validations for enrolment, graduation semester and year
  validates :enrol_year, :grad_year, presence: true, numericality: { only_integer: true }
  validates :grad_year, comparison: { greater_than: :enrol_year }
  validates :enrol_semester, :grad_semester, presence: true

  # Validations for academic standing and preference
  validates :academic_standing, inclusion: { in: academic_standings.keys }
  validates :preference_online, inclusion: { in: [true, false] }

  # Student courses association
  # has_and_belongs_to_many :courses
  has_many :student_courses, dependent: :destroy
  has_many :courses, through: :student_courses

  belongs_to :major

  belongs_to :track, optional: true

  belongs_to :emphasis, optional: true
  # belongs_to :emphasis, foreign_key: :emphases_id, optional: true
  has_many :schedules
  def total_credits_completed
    courses.sum(:credit_hours)
  end
end
