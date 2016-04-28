FactoryGirl.define do
  factory :user do
    full_name { Faker::Name.name }
    username { Faker::Internet.user_name("#{full_name}") }
    email { Faker::Internet.email("#{username}") }
    pass = Faker::Internet.password
    password pass
    password_confirmation pass

    trait :superadmin do
      email 'superadmin@example.com'
      superadmin true
    end
    
    trait :admin do
      email 'admin@example.com'
      admin true
    end

    trait :coach do
      transient do
        coach_pg { PermissionGroup.find_by(title: 'Coach') || create(:coach_permission_group) }
      end

      can_dashboard true
      can_create_assignment_group true
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
        usr.user_externals << build(:user_external, user: usr)
      end
    end

    trait :with_assignment_group do
      after(:build) do |usr|
        usr.assignment_groups << FactoryGirl.build(:assignment_group, :with_template, owner: usr)
      end
    end
   
    trait :with_no_permissions do
      roles { [] }
    end

    factory :no_permissions_user, traits: [:with_no_permissions]
    factory :superadmin, traits: [:superadmin]
    factory :admin, traits: [:admin]
    factory :coach, traits: [:coach, :with_uex, :with_assignment_group]
    factory :student, traits: [:student]
  end
end
