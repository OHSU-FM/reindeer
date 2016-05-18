FactoryGirl.define do
  factory :assignment_group, class: Assignment::AssignmentGroup do
    title { Faker::Lorem.sentence }
    desc_md { Faker::Lorem.paragraph }
    association :owner, factory: :admin, strategy: :build
    association :assignment_group_template, :with_surveys

    # also creates tables
    trait :with_full_template do
      association :assignment_group_template, :with_full_surveys
    end

    trait :with_users do
      after(:create) do |ag|
        ag.user_ids = create_list(:user, 3).map {|u| u.id.to_s }
        ag.save!
      end
    end
  end
end
