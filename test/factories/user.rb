FactoryGirl.define do
  factory :user do
    username Faker::Name.first_name
    email Faker::Internet.email
    pass = Faker::Internet.password
    password pass
    password_confirmation pass 
    full_name 'A test user'
    
    trait :default do
      is_ldap false
      can_dashboard true
      can_lime true
    end

    trait :admin do
      admin true
      superadmin true
    end
  end
end
