FactoryGirl.define do
  factory :p_ls_g_one, class: PermissionLsGroup do
    association :lime_survey
    association :permission_group
  end
end
