FactoryGirl.define do
  factory :assignment_group_template, class: 'Assignment::AssignmentGroupTemplate' do
    association :permission_group
    title Faker::Hacker.noun
    desc_md Faker::Hacker.say_something_smart
    active true

    trait(:with_surveys) do 
      after(:build) do |agt|
        agt.lime_surveys = build_list(:lime_survey, 2)
      end
    end
    
    after(:create) do |agt|
      create_list(:assignment_group, 2, assignment_group_template: agt)
    end
  
  end
end
