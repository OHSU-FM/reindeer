FactoryGirl.define do
  factory :lime_group do
    # association :lime_survey if only we had a lime_survey factory
    group_name "test"
    before(:create) do |lg|
      LimeSurvey.find_by(sid: 12345).lime_groups << lg
    end
  end
end
