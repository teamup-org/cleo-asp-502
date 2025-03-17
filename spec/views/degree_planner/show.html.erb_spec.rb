# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'degree_planner/show.html.erb', type: :view do
  let(:student) { double('Student', full_name: 'John Doe', avatar_url: nil, google_id: '12345', id: 1) }
  let(:current_student_login) { student }

  before do
    assign(:student, student)
    assign(:track_options, ['Track 1', 'Track 2'])
    assign(:course_prerequisite_status, [])
    assign(:emphasis_options, ['Emphasis 1', 'Emphasis 2'])
    assign(:courses, [])

    allow(view).to receive(:current_student_login).and_return(student)
    allow(student).to receive(:is_admin?).and_return(true)
    allow(student).to receive(:google_id).and_return('12345')
    allow(current_student_login).to receive(:is_admin?).and_return(true)
    allow(view).to receive(:student_dashboard_path).and_return("/student_dashboard/#{student.google_id}")
    allow(view).to receive(:profile_student_path).with(student).and_return("/profile/student/#{student.google_id}")
    allow(view).to receive(:student_degree_planner_path).with(student.google_id).and_return("/student/degree_planner/#{student.google_id}")
    allow(view).to receive(:support_index_path).and_return('/support')
    allow(view).to receive(:destroy_student_login_session_path).and_return('/logout')

    render
  end

  it 'renders the Apply Filters button' do
    expect(rendered).to have_selector("input[type=submit][value='Apply Filters']")
  end

  it 'renders the courses table' do
    expect(rendered).to have_selector('table')
  end

  it 'displays the recommended courses in a box' do
    expect(rendered).to have_selector('.semester2-container')
  end

  it 'applies the correct button width' do
    expect(rendered).to have_selector("input[type=submit][class='action-button filter-button']")
  end
end
