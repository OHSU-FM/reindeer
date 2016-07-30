FactoryGirl.define do
  factory :assignment_group_template, class: 'Assignment::AssignmentGroupTemplate' do
    title Faker::Hacker.noun
    desc_md Faker::Hacker.say_something_smart
    active true

    transient do
      ls_count 1
    end

    after(:build) do |agt, evaluator|
      agt.lime_surveys = build_list(:lime_survey, evaluator.ls_count)
    end

    trait :with_full_survey do
      after(:build) do |agt|
        agt.lime_surveys = create_list(:lime_survey_full, 1)
      end
    end

    trait :with_assignment_groups do
      after(:build) do |agt|
        agt.assignment_groups = create_list(:assignment_group, 2, assignment_group_template: agt)
      end
    end
  end
end
