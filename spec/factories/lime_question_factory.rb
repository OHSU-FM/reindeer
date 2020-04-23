FactoryBot.define do
  factory :lime_question do
    question { Faker::Lorem.sentence(3) }
    title { Faker::Lorem.word }
    #question_order 0
    #lime_group
    #sid { lime_group.sid }
  end
end
