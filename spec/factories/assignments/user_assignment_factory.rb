FactoryGirl.define do
  factory :user_assignment, class: Assignment::UserAssignment do
    association :survey_assignment
    association :user, factory: :student

    after(:build) do |ua|
      ua.lime_token_tid = ua.lime_survey.lime_tokens.pluck(:tid).flatten.first.to_i
    end

    trait :with_user_responses do
      after(:build) do |ua|
        ua.user_responses = create_list(:user_response, 2, user_assignment: ua)
      end
    end
  end
end
