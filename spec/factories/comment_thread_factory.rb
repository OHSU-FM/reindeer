FactoryGirl.define do
  factory :comment_thread do
    association :first_user, factory: :coach
    association :second_user, factory: :student
  end
end
