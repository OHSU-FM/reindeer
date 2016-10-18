require "spec_helper"

describe LimeSurvey do
  it "has a valid factory" do
    expect(create :lime_survey).to be_valid
  end

  it "can create tables" do
    survey = create :lime_survey, :with_tables
    tables = ActiveRecord::Base.connection.tables
    tables.select!{|t|t.include?(survey.sid.to_s)}
    expect(tables.count == 2).to be_truthy
  end

  describe "methods" do
    it "#parent_questions" do
      s = create :lime_survey_full
      expect(s.parent_questions).to be_an(Array)
      expect(s.parent_questions.first).to be_a(LimeQuestion)
    end

    it "#lime_questions" do
      s = create :lime_survey_full
      lq = LimeQuestion.first
      expect(s.find_question :qid, lq.qid).to eq lq
    end

    it "#completed_surveys_count" do
      s = create :lime_survey_full
      expect(s.completed_surveys_count).to eq 1
    end

    it "#last_updated" do
      s = create :lime_survey_full
      expect(s.last_updated).to eq "2015-08-08 00:00:00"
    end

    it "#column_names" do
      s = create :lime_survey_full
      expect(s.column_names).to eq LimeQuestion.all.map{ |q|
        [q.title, "#{q.sid}X#{q.gid}X#{q.qid}"]
      }
    end

    it "#title" do
      s = create :lime_survey_full, :with_languagesettings
      expect(s.title).to eq s.lime_surveys_languagesettings.first.surveyls_title
    end

    it "#pretty_title" do
      s = create :lime_survey_full, :with_languagesettings
      l_settings = s.lime_surveys_languagesettings.first
      expect(s.pretty_title).to eq l_settings.surveyls_title.split(":").last
    end

    it "#pretty_title with four layer title" do
      s = create :lime_survey_full, :with_languagesettings
      l_settings = s.lime_surveys_languagesettings.first
      l_settings.surveyls_title = "one:two:three:four"; l_settings.save!
      expect(s.pretty_title).to eq "two: four \n"
    end
  end

  describe "associated classes" do
    it "include lime_stats" do
      s = create :lime_survey
      expect(s.lime_stats).to be_an_instance_of(LimeExt::LimeStat::LimeStat)
    end

    it "include lime_data" do
      s = create :lime_survey
      expect(s.lime_data).to be_an_instance_of(LimeExt::LimeData)
    end

    it "include lime_tokens" do
      s = create :lime_survey
      expect(s.lime_tokens).to be_an_instance_of(LimeExt::LimeTokens)
    end
  end
end
