require 'test_helper'
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

  it "must be able to save and create" do
    @rule.save.must_equal true
    assert SyncTrigger.count == 1
  end

  it 'must be able to create and destroy a trigger' do
    @rule.save
    SyncTrigger.count.must_equal 1
    @rule.destroy
    SyncTrigger.count.must_equal 0  
  end

  it 'must trigger updates to token table' do
    @rule.save
    create_min_response 936387, :tokens=>{attribute_1: '25.00'}
    LimeSurvey.find(936387).lime_tokens.dataset.first['attribute_1'].to_i.must_equal 25 
    create_min_response 174976, :response=>{col1: '33.00'}
    LimeSurvey.find(174976).lime_data.dataset.first['174976X123X6036'].to_i.must_equal 33
    LimeSurvey.find(936387).lime_tokens.dataset.first['attribute_1'].to_i.must_equal 33
  end

  it "must fail on save when lime survey doesn't exists" do
    @rule.sid_src = 12345 #<- Does not exist
    @rule.save.must_equal false  #<- Should return false
    SyncTrigger.count.must_equal 0
  end

  it 'must CASCADE and be deleted when primary lime_survey has been deleted' do
    @rule.save
    SyncTrigger.count.must_equal 1
    q="DELETE FROM #{LimeExt.table_prefix}_surveys WHERE sid = 174976;"
    ActiveRecord::Base.connection.execute(q)
    SyncTrigger.count.must_equal 0
  end
  
  it 'must CASCADE and be deleted when secondary lime_survey has been deleted' do
    @rule.save
    SyncTrigger.count.must_equal 1
    q="DELETE FROM #{LimeExt.table_prefix}_surveys WHERE sid = 936387;"
    ActiveRecord::Base.connection.execute(q)
    SyncTrigger.count.must_equal 0
  end

  it 'must be able to delete when responses table has been renamed' do
    @rule.save.must_equal true
    SyncTrigger.count.must_equal 1
    ActiveRecord::Base.connection.execute('ALTER TABLE lime_survey_936387 RENAME TO lime_survey_936387_OLD;')
    ActiveRecord::Base.connection.execute('ALTER TABLE lime_survey_174976 RENAME TO lime_survey_174976_OLD;')
    SyncTrigger.count.must_equal 1
    @rule.destroy
    SyncTrigger.count.must_equal 0
  end

end
