FactoryGirl.define do
  factory :goal do
    association :user
    status "Not Started"
    type "Goal"
    tag "PC"
    title { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    target_date { Faker::Date.forward(7) }
  end
end
