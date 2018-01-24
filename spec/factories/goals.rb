FactoryBot.define do
  factory :goal do
    name { Faker::Lorem.word }
    user
  end
end
