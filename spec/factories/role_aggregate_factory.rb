# require "factories/lime_survey"

FactoryGirl.define do
  factory :role_aggregate do
    agg_fieldname "12345X123X6039" # {sid}X{gid}X{qid}
    agg_title_fieldname { agg_fieldname }
    pk_fieldname "12345X123X6039"
    pk_title_fieldname { pk_fieldname }
    before(:create) do |ra|
      ls = LimeSurvey.find_by(sid: 12345)
      ra.lime_survey = ls
      ls.role_aggregate = ra
    end
  end
end
