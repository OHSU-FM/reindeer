FactoryGirl.define do
  factory :source do
    review

    trait :role_aggregate do
      after(:build) do |s|
        s.sourceable = create :role_aggregate
      end
    end
  end
end
