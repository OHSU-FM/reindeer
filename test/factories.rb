FactoryGirl.define do
  sequence(:random_id) {|n|
    @random_ids ||= (1..100000).to_a.shuffle
    @random_ids[n]
  }



  factory :dashboard do
    user
    theme 'oregon-coast'
  end

  factory :dashboard_widget do
    dashboard
  end
end
