FactoryBot.define do
  factory :survey_assignment, class: Assignment::SurveyAssignment do
    association :assignment_group, :with_full_template
    lime_survey { assignment_group.lime_surveys.first }

    trait :with_user_assignment do
      after(:create) do |sa|
        sa.user_assignments = create_list(:user_assignment, 1, survey_assignment: sa)
      end
    end
  end
end
