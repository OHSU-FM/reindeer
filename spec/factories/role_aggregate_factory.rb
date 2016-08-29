FactoryGirl.define do
  factory :role_aggregate do
    association :lime_survey, factory: :lime_survey_full
    default_view "graph"

    trait :ready do
      after(:create) do |ra, evaluator|
        lq = ra.lime_survey.lime_groups.first.lime_questions.first
        l_string = "#{lq.sid}X#{lq.gid}X#{lq.qid}"
        ra.agg_fieldname, ra.pk_fieldname = l_string, l_string
        ra.save!
      end
    end
  end
end
