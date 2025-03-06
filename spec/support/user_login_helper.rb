# frozen_string_literal: true

# spec/helpers/user_login_helper.rb
module UserLoginHelper
  def mock_current_student_login
    student_login = instance_double(
      StudentLogin,
      email: 'JohnDoe@gmail.com',
      full_name: 'John Doe',
      uid: '123456789', # Make sure this matches the Student's google_id
      avatar_url: nil,
      is_admin?: false
    )
    allow_any_instance_of(ApplicationController).to receive(:current_student_login).and_return(student_login)

    # Create a real Student instance instead of an instance_double
    student = Student.create!(
      google_id: '123456789', # Ensure this matches the uid above
      first_name: 'John',
      last_name: 'Doe',
      email: 'johndoe@gmail.com',
      enrol_year: 2020,
      grad_year: 2024,
      enrol_semester: 0,
      grad_semester: 1,
      major: Major.create!(mname: 'Computer Science', cname: 'Engineering')
    )

    # Stub Student.find to return the correct student
    allow(Student).to receive(:find).with('123456789').and_return(student)
    allow(Student).to receive(:find_by).with(google_id: '123456789').and_return(student)
  end



  def mock_current_student_login_admin
    student_login = instance_double(
      StudentLogin,
      email: 'JohnDoe@gmail.com',
      full_name: 'John Doe',
      uid: '12345',
      avatar_url: nil,
      is_admin?: true
    )
    allow_any_instance_of(ApplicationController).to receive(:current_student_login).and_return(student_login)

    student = instance_double(Student, google_id: '12345', is_admin: true)
    allow(Student).to receive(:find).and_return(student)
  end
end
