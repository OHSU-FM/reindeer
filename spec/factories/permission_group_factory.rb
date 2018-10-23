FactoryBot.define do

  factory :permission_group do
    title { Faker::Lorem.sentence }

    trait :student do
      title "Student"
    end

    trait :with_users do
      transient do
        users_count 1
      end

      after(:create) do |pg, evaluator|
        create_list(:user_w_externals, evaluator.users_count, permission_group: pg)
      end
    end

    trait :with_lime_surveys do
      transient do
        ls_count 1
      end

      after(:create) do |pg, evaluator|
        create_list(:lime_survey, evaluator.ls_count, permission_group: pg)
      end
    end

    factory :student_permission_group, traits: [:student]
  end
end
