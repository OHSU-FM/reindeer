FactoryGirl.define do
  factory :assignment_group, class: Assignment::AssignmentGroup do
    association :owner, factory: :coach
    association :assignment_group_template

    title { Faker::Lorem.sentence }
    desc_md { Faker::Lorem.paragraph }
  end
end
