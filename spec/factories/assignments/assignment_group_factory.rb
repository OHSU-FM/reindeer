FactoryGirl.define do
  factory :assignment_group, class: Assignment::AssignmentGroup do
    title { Faker::Lorem.sentence }
    desc_md { Faker::Lorem.paragraph }
    association :assignment_group_template, :with_surveys
    association :cohort

    # also creates tables
    trait :with_full_template do
      association :assignment_group_template, :with_full_survey
    end

    trait :with_users do
      association :cohort, :with_users
    end

    trait :with_comments do
      with_users
      after(:create) do |ag|
        create_list(:assignment_comment, 1, commentable: ag, user: ag.owner)
      end
    end
  end
end
