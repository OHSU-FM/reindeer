FactoryBot.define do
  factory :user do
    full_name { Faker::Name.name }
    username { Faker::Internet.user_name("#{full_name}") }
    email { Faker::Internet.email("#{username}") }
    pass = Faker::Internet.password
    password pass
    password_confirmation pass

    trait :with_dashboard do
      can_dashboard true
      association :dashboard, :with_widgets, strategy: :build
    end

    trait :superadmin do
      superadmin true
    end

    trait :admin do
      admin true
    end

    trait :coach do
      can_dashboard true
      can_lime true
      permission_group

      after :create do |c|
        create :cohort, owner: c
      end
    end

    trait :student do
      can_dashboard true
      participant true
      permission_group
    end

    trait :with_uex do
      after(:build) do |usr|
        usr.user_externals << build(:user_external, user: usr)
      end
    end

    trait :with_no_permissions do
      roles { [] }
    end

    factory :no_permissions_user, traits: [:with_no_permissions]
    factory :superadmin, traits: [:superadmin]
    factory :admin, traits: [:admin]
    factory :coach, traits: [:coach, :with_uex]
    factory :student, traits: [:student]
    factory :user_w_externals, traits: [:with_uex]
  end
end
