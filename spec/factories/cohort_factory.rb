FactoryBot.define do
  factory :cohort do
    permission_group
    association :owner, factory: :coach

    #trait :with_users do
    #  transient do
    #    users_count 2
    #  end

      #after(:build) do |c, evaluator|
      #  c.users = create_list(:student, evaluator.users_count, cohort: c)
      #end
    #end
  end
end
