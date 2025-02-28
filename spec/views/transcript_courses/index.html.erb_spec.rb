require 'rails_helper'

RSpec.describe "transcript_courses/index", type: :view do
  before(:each) do
    assign(:transcript_courses, [
      TranscriptCourse.create!(
        student_id: "Student",
        course_id: "",
        grade: "Grade",
        semester: 2,
        year: 3
      ),
      TranscriptCourse.create!(
        student_id: "Student",
        course_id: "",
        grade: "Grade",
        semester: 2,
        year: 3
      )
    ])
  end

  it "renders a list of transcript_courses" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Student".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Grade".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
  end
end
