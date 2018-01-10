FactoryBot.define do
  factory :user_assignment, class: Assignment::UserAssignment do
    association :survey_assignment
    association :user, factory: :student

    before(:create) do |ua|
      ua.lime_token_tid = ua.lime_survey.lime_tokens.pluck(:tid).flatten.first.to_i
    end

    trait :with_user_responses do
      transient do
        ur_count 1
        owner_status "hi!"
      end

      after(:build) do |ua, evaluator|
        ua.user_responses = create_list(:user_response, evaluator.ur_count,
                                        owner_status: evaluator.owner_status, user_assignment: ua)
      end
    end
  end
end
