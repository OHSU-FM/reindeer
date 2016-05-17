FactoryGirl.define do
  factory :user_response, class: Assignment::UserResponse do
    association :user_assignment

    after(:create) do |ur|
      ua = ur.user_assignment
      ua.lime_token_tid = ua.survey_assignment.lime_survey.lime_tokens.pluck :tid
    end
  end
end
