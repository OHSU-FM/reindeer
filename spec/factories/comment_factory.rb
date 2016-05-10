FactoryGirl.define do

  factory :comment do
    body Faker::Lorem.paragraph
    association :user

    trait :assignment_comment do
      association :commentable, factory: :assignment_group
    end

    trait :user_response_comment do
      association :commentable, factory: :user_response
    end
  end
end

