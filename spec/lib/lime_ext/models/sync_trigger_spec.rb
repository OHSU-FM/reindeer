require 'rails_helper'
SyncTrigger = LimeExt::SyncTrigger

describe SyncTrigger do

  before do
    create_min_survey 174976
    create_min_survey 936387

    SyncTrigger.destroy_all
    @rule = SyncTrigger.new
    @rule.sid_src  = 174976
    @rule.sid_dest = 936387
    @rule.map_src  = :token
    @rule.map_dest = :token
    @rule.cols = {
      '174976X123X6036' => :attribute_1
    }
  end

  it "must be able to save" do
    @rule.save!
  end

  it 'must be able to create and destroy a trigger' do
    @rule.save!
    expect(SyncTrigger.count).to eq 1
    @rule.destroy
    expect(SyncTrigger.count).to eq 0
  end

  # TODO fix this
  # create_min_response doesn't create a LimeSurvey object, so find fails
  # it 'must trigger updates to token table' do
  #   @rule.save
  #   create_min_response 936387, :tokens=>{attribute_1: '25.00'}
  #   expect(LimeSurvey.find(936387).lime_tokens.dataset.first['attribute_1'].to_i).to eq 25
  #   create_min_response 174976, :response=>{col1: '33.00'}
  #   expect(LimeSurvey.find(174976).lime_data.dataset.first['174976X123X6036'].to_i).to eq 33
  #   expect(LimeSurvey.find(936387).lime_tokens.dataset.first['attribute_1'].to_i).to eq 33
  # end

  it "must fail on save when lime survey doesn't exists" do
    @rule.sid_src = 12345 #<- Does not exist
    expect(@rule.save).to eq false  #<- Should return false
    expect(SyncTrigger.count).to eq 0
  end

  # TODO fix this
  # create_min_response doesn't create a LimeSurvey object, so find fails
  # it 'must CASCADE and be deleted when primary lime_survey has been deleted' do
  #   @rule.save
  #   expect(SyncTrigger.count).to eq 1
  #   q="DELETE FROM #{LimeExt.table_prefix}_surveys WHERE sid = 174976;"
  #   ActiveRecord::Base.connection.execute(q)
  #   expect(SyncTrigger.count).to eq 0
  # end

  # TODO fix this
  # create_min_response doesn't create a LimeSurvey object, so find fails
  # it 'must CASCADE and be deleted when secondary lime_survey has been deleted' do
  #   @rule.save
  #   expect(SyncTrigger.count).to eq 1
  #   q="DELETE FROM #{LimeExt.table_prefix}_surveys WHERE sid = 936387;"
  #   ActiveRecord::Base.connection.execute(q)
  #   expect(SyncTrigger.count).to eq 0
  # end

  it 'must be able to delete when responses table has been renamed' do
    expect(@rule.save).to eq true
    expect(SyncTrigger.count).to eq 1
    ActiveRecord::Base.connection.execute('ALTER TABLE lime_survey_936387 RENAME TO lime_survey_936387_OLD;')
    ActiveRecord::Base.connection.execute('ALTER TABLE lime_survey_174976 RENAME TO lime_survey_174976_OLD;')
    expect(SyncTrigger.count).to eq 1
    @rule.destroy
    expect(SyncTrigger.count).to eq 0
  end

end
