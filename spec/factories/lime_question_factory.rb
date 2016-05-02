FactoryGirl.define do
  factory :lime_question do
    qid { rand(1000..9999) }
    question "a test question"
    question_order 0
    lime_group { LimeGroup.first || create(:lime_group) }
  end
end
