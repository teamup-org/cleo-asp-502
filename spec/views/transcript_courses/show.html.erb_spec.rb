require 'rails_helper'

RSpec.describe "transcript_courses/show", type: :view do
  before(:each) do
    assign(:transcript_course, TranscriptCourse.create!(
      student_id: "Student",
      course_id: "",
      grade: "Grade",
      semester: 2,
      year: 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Student/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Grade/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end
