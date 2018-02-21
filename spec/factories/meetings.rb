FactoryBot.define do
  factory :meeting, class: Coaching::Meeting do
    user
    subject "MyString"
    date Date.tomorrow
    location "MyString"
    status "Scheduled"
    notes "MyText"
  end
end
