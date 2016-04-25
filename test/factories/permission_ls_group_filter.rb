FactoryGirl.define do
  factory :plg_filter, class: 'PermissionLsGroupFilter' do
    ident_type { lime_question.title }
  end
end
