# factories/courses.rb
FactoryBot.define do
  factory :course do
    ccode { 'CSCE' }
    cnumber { 431 }
    credit_hours { 3 }
    lecture_hours { 2 }
    lab_hours { 1 }
  end
end
