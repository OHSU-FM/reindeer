FactoryGirl.define do
  factory :user_response, class: Assignment::UserResponse do
    association :user_assignment
    title { Faker::Hacker.ingverb }
    content { Faker::Hacker.say_something_smart }
    category "test user_response"
    completion_target { Faker::Date.backward(14) }
    owner_status { Faker::Lorem.sentence(3) }
    submitdate { Faker::Date.between(2.days.ago, Date.today) }

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
