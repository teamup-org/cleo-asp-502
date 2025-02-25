require 'rails_helper'

RSpec.describe "transcript_courses/new", type: :view do
  before(:each) do
    assign(:transcript_course, TranscriptCourse.new(
      student_id: "MyString",
      course_id: "",
      grade: "MyString",
      semester: 1,
      year: 1
    ))
  end

  it "renders new transcript_course form" do
    render

    assert_select "form[action=?][method=?]", transcript_courses_path, "post" do

      assert_select "input[name=?]", "transcript_course[student_id]"

      assert_select "input[name=?]", "transcript_course[course_id]"

      assert_select "input[name=?]", "transcript_course[grade]"

      assert_select "input[name=?]", "transcript_course[semester]"

      assert_select "input[name=?]", "transcript_course[year]"
    end
  end
end
