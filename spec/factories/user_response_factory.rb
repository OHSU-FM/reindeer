FactoryGirl.define do
  factory :user_response, class: Assignment::UserResponse do
    trait :with_user do
      association :user, strategy: :build
    end
  end
end
