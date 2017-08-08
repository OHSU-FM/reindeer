FactoryGirl.define do

  factory :comment do
    body { Faker::Lorem.sentence }
    association :user
  end
end
