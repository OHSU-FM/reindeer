FactoryGirl.define do
  factory :pls_group, class: PermissionLsGroup do
    permission_group { PermissionGroup.first || create(:coach_permission_group) }
    enabled true

    before(:create) do |plsg|
      if RoleAggregate.first.nil?
        create(:role_aggregate)
      end
      ls = LimeSurvey.find_by(sid: 12345)
      plsg.lime_survey = ls
    end

    after(:build) do |plsg|
      plsg.permission_ls_group_filters << build_list(:plg_filter, 1, permission_ls_group: plsg)
    end
  end
end
