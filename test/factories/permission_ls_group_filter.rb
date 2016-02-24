FactoryGirl.define do
  factory :plg_filter, class: PermissionLsGroupFilter do
    lime_question { LimeQuestion.first }
    ident_type { lime_question.title }
  end
end
