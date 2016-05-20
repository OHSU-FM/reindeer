FactoryGirl.define do
  factory :user_response, class: Assignment::UserResponse do
    association :user_assignment

    after(:create) do |ur|
      ua = ur.user_assignment
      ua.lime_token_tid = ua.survey_assignment.lime_survey.lime_tokens.pluck :tid
    end

    trait :with_comments do
      after(:create) do |ur|
        create_list(:user_response_comment, 1, commentable: ur, user: ur.user)
        create_list(:user_response_comment, 1, commentable: ur, user: ur.assignment_group.owner)
      end
    end
  end
end
