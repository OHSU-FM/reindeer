class LimeQuestionAttribute < ActiveRecord::Base
    self.primary_key = :qaid
    belongs_to :lime_question, :foreign_key=>:qid, :primary_key=>:qid, :inverse_of=>:lime_question_attributes
    default_scope{select('qaid, qid, attribute as xattribute, value, language')}
    rails_admin do
        navigation_label "Lime Survey"
    end

end

LimeQuestionAttribute.columns.find{|col|col.name=='attribute'}.instance_variable_set(:@name,'xattribute')
