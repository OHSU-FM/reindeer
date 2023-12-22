FactoryBot.define do
  factory :course do
    course_number { "MyString" }
    course_name { "MyString" }
    content_type { "MyString" }
    medhub_course_id { 1 }
    rural { false }
  end
end
