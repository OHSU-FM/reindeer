FactoryBot.define do
  factory :comment_thread do
    assignment_group_thread
    association :first_user, factory: :coach
    association :second_user, factory: :student

    trait :assignment_group_thread do
      association :threadable, factory: :assignment_group
    end
  end
end
