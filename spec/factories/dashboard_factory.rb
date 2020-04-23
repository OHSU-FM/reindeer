FactoryBot.define do

  factory :dashboard do
    #theme 'oregon-coast'
    trait :with_widgets do
      after(:build) do |dashboard|
        dashboard.dashboard_widgets = build_list :dashboard_widget, 2
      end
    end
  end

end

