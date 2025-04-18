# frozen_string_literal: true

class DegreeRequirement < ApplicationRecord
  validates :year,:course_id, presence: true
  validates :sem, presence: true, numericality: { only_integer: true }
  validates :course, presence: true

  belongs_to :course
  belongs_to :major

  validates :course_id, uniqueness: { scope: %i[major_id year] }

  before_validation :set_default_year, if: -> { year.nil? }

  private

  def set_default_year
    self.year = Time.current.year
  end
end
