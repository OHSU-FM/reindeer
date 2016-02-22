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
      transient do
        coach_pg { PermissionGroup.find_by(title: 'Coach') || create(:coach_permission_group) }
      end

      can_dashboard true
      can_lime true
      permission_group { coach_pg }
    end

    trait :student do
      transient do
        student_pg { PermissionGroup.find_by(title: 'Student') || create(:student_permission_group) }
      end

      can_dashboard true
      participant true
      permission_group { student_pg }
    end

    trait :with_uex do
      after(:build) do |usr|
        usr.user_externals << build_list(:user_external, 1, user: usr)
      end
    end

    factory :admin, traits: [:admin]
    factory :coach, traits: [:coach, :with_uex]
    factory :student, traits: [:student]
  end
end
