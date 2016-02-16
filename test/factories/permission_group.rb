FactoryGirl.define do
  factory :high_permission_group, class: PermissionGroup do
    title "High"
    pinned_survey_group_titles ["test"]
  end

  factory :low_permission_group, class: PermissionGroup do
    title "Low"
  end
end
