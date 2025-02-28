json.extract! transcript_course, :id, :student_id, :course_id, :grade, :semester, :year, :created_at, :updated_at
json.url transcript_course_url(transcript_course, format: :json)
