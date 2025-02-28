require 'rails_helper'

RSpec.describe "transcript_courses/edit", type: :view do
  let(:transcript_course) {
    TranscriptCourse.create!(
      student_id: "MyString",
      course_id: "",
      grade: "MyString",
      semester: 1,
      year: 1
    )
  }

  before(:each) do
    assign(:transcript_course, transcript_course)
  end

  it "renders the edit transcript_course form" do
    render

    assert_select "form[action=?][method=?]", transcript_course_path(transcript_course), "post" do

      assert_select "input[name=?]", "transcript_course[student_id]"

      assert_select "input[name=?]", "transcript_course[course_id]"

      assert_select "input[name=?]", "transcript_course[grade]"

      assert_select "input[name=?]", "transcript_course[semester]"

      assert_select "input[name=?]", "transcript_course[year]"
    end
  end
end
