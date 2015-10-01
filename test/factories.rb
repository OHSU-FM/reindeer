FactoryGirl.define do

  factory :user do
    email 'test@example.com'
    username 'test_user'
    full_name 'A test user'
    password "password"
    password_confirmation "password"
    admin false
    is_ldap false
    can_dashboard true
    can_lime true
  end
  
  factory :no_permissions_user, class: User do
    email 'no_permissions_user@example.com'
    username 'no_permissions_user'
    full_name 'A test user with no permissions'
    password "password"
    password_confirmation "password"
    is_ldap false
  end
  
  factory :admin, class: User do
    email 'admin@example.com'
    username 'test_admin'
    full_name 'A test admin user'
    password "password"
    password_confirmation "password"
    admin true
    superadmin true
    is_ldap false
  end
 
  factory :dashboard do
    user
    theme 'oregon-coast'
  end

  factory :dashboard_widget do
    dashboard

  end
end
