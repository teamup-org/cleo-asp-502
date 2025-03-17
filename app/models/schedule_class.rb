class ScheduleClass < ApplicationRecord
  belongs_to :class_attribute
    belongs_to :schedule, foreign_key: [:semester, :student_google_id], primary_key: [:semester, :student_google_id]

    validates :class_attribute_id, uniqueness: {
      scope: [:semester, :student_google_id],
      message: "This course is already in your schedule."
    }
    validate :course_id_uniqueness
    def course_id_uniqueness
      existing_course = ScheduleClass.joins(:class_attribute)
                                    .where(semester: semester, student_google_id: student_google_id)
                                    .where(class_attributes: { course_id: class_attribute.course_id })
                                    .exists?

      errors.add(:base, "This course is already in your schedule.") if existing_course
    end
  end