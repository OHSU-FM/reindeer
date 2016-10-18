FactoryGirl.define do
  factory :plg_filter, class: "PermissionLsGroupFilter" do
    association :lime_question, title: "TestQuestion"
    ident_type { lime_question.title }
  end
end
