FactoryGirl.define do

  factory :dashboard do
    theme 'oregon-coast'
    trait :with_widgets do
      after(:build) do |dashboard|
        dashboard.dashboard_widgets = build_list :dashboard_widgets, 2
      end
    end
  end

end

