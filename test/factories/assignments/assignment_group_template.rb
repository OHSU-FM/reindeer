FactoryGirl.define do
  factory :assignment_group_template, class: Assignment::AssignmentGroupTemplate do
    permission_group { PermissionGroup.find_by(title: "Student") || create(:student_permission_group) }
    title Faker::Hacker.noun
    desc_md Faker::Hacker.say_something_smart
    active true
    sids ["12345"]

    after(:create) do |agt|
      create_list(:assignment_group, 2, assignment_group_template: agt)
    end
  end
end
