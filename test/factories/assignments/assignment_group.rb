FactoryGirl.define do
  factory :assignment_group, class: Assignment::AssignmentGroup do
    association :owner, factory: :coach
    assignment_group_template
    title { assignment_group_template.title }
    desc_md { assignment_group_template.desc_md }
  end
end
