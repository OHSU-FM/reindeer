FactoryGirl.define do

  factory :permission_group do
    title { Faker::Hipster.sentence }

    trait :coach do
      title "Coach"
      pinned_survey_group_titles ["test"]
    end

    trait :student do
      title "Student"
    end

    factory :coach_permission_group, traits: [:coach]
    factory :student_permission_group, traits: [:student]
  end
end
