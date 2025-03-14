class ClassAttribute < ApplicationRecord
    belongs_to :students
    has_many :class_attributes
  end
  