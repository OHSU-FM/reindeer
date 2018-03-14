FactoryBot.define do
  factory :meeting, class: Coaching::Meeting do
    user
    subject "MyString"
    date Date.tomorrow
    location "MyString"
    m_status "Scheduled"
    notes "MyText"
  end
end
