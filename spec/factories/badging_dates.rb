FactoryBot.define do
  factory :badging_date do
    permission_group_id { 1 }
    release_date { "2024-02-07" }
    last_review_end_date { "2024-02-07" }
    next_review_end_date { "2024-02-07" }
  end
end
