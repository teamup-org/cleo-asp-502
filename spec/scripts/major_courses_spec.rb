require 'rails_helper'
require 'csv'

RSpec.describe "Major Courses CSV" do
  let(:csv_path) { Rails.root.join("lib", "data", "manual", "major_courses.csv") }

  it "exists in the expected directory" do
    expect(File.exist?(csv_path)).to be_truthy
  end

  it "has a valid CSV format with headers" do
    csv_content = CSV.read(csv_path, headers: true)
    expect(csv_content.headers).to include("major", "course_code", "course_number", "rec_sem", "year")
  end

  it "has at least one row of data" do
    csv_content = CSV.read(csv_path, headers: true)
    expect(csv_content.count).to be > 0
  end
end
