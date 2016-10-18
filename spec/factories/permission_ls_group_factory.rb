FactoryGirl.define do
  factory :pls_group, class: PermissionLsGroup do
    association :permission_group, :with_users
    lime_survey
    enabled true

    after(:build) do |plsg|
      plsg.permission_ls_group_filters << build_list(:plg_filter, 1, permission_ls_group: plsg)
    end
  end
end
