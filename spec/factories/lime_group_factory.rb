FactoryBot.define do
  factory :lime_group do
    association :lime_survey
    group_name { Faker::Hacker.noun }
  end
end
