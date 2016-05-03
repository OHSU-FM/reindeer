FactoryGirl.define do

  factory :comment do
    body Faker::Lorem.paragraph
    
    trait :with_defaults do
      association :user
    end
  end

end


