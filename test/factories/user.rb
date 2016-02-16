FactoryGirl.define do
  factory :user do
    full_name Faker::Name.name
    username { Faker::Internet.user_name("#{full_name}") }
    email { Faker::Internet.email("#{username}") }
    pass = Faker::Internet.password
    password pass
    password_confirmation pass

    trait :admin do
      id 1
      email 'test@example.com'
      superadmin true
    end

    trait :coach do
      permission_group coach_permission_group
      can_dashboard true
      can_lime true
    end

    factory :admin, traits: [:admin]
    factory :coach, traits: [:coach]
  end
end
