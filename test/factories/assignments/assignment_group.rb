FactoryGirl.define do
  factory :assignment_group, class: Assignment::AssignmentGroup do
    title { Faker::Lorem.sentence }
    desc_md { Faker::Lorem.paragraph }
    association :owner, factory: :admin, strategy: :build

    trait :with_template do
      association :assignment_group_template
    end

  end

end
