FactoryGirl.define do
  factory :pls_group, class: PermissionLsGroup do
    association :permission_group, :with_users
    lime_survey :full
    enabled true

    after(:build) do |plsg|
      g = plsg.lime_survey.lime_groups.first
      q = g.lime_questions.max_by{|lq| lq.qid}; q.title = "TestQuestion"; q.save!
      plsg.permission_ls_group_filters << build_list(:plg_filter,
                                                     1,
                                                     lime_question: q,
                                                     permission_ls_group: plsg)
    end
  end
end
