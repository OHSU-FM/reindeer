FactoryGirl.define do
  factory :action_plan_item do
    association :goal
    description { Faker::Lorem.sentence }
  end
end
