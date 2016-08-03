FactoryGirl.define do

  factory :comment do
    body { Faker::Hipster.sentence }
    association :user

    trait :assignment_comment do
      association :commentable, factory: :assignment_group
    end

    trait :user_response_comment do
      association :commentable, factory: :user_response
    end

    factory :assignment_comment, traits: [:assignment_comment]
    factory :user_response_comment, traits: [:user_response_comment]
  end
end

