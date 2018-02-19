FactoryBot.define do
  factory :goal do
    name { Faker::Lorem.word }
    user
    target_date Date.tomorrow
    competency_tag "pc"
  end
end
