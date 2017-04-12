require 'rails_helper'

describe LimeSurvey do
  it 'has a valid factory' do
    create(:lime_survey)
  end

  it 'can create tables' do
    survey = create(:lime_survey, :with_tables)
    tables = ActiveRecord::Base.connection.tables
    tables.select!{|t|t.include?(survey.sid.to_s)}
    assert(tables.count == 2, true)
  end

  describe "methods" do
    it "#last_updated" do
      survey = create :lime_survey, :with_tables, :with_response
      expect(survey.last_updated).to eq "2015-08-08 00:00:00"
    end
  end
end
