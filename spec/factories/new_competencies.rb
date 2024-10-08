FactoryBot.define do
  factory :new_competency do
    user_id { 1 }
    permission_group_id { 1 }
    student_uid { "MyString" }
    email { "MyString" }
    medhub_id { "MyString" }
    course_name { "MyString" }
  end
end
