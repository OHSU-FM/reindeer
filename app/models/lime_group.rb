class LimeGroup < ActiveRecord::Base
    self.primary_key = :gid
    belongs_to :user, :inverse_of=>:lime_groups
    belongs_to :lime_survey,
        :foreign_key=>:sid,
        :primary_key=>:sid,
        :inverse_of=>:lime_groups
    has_many :lime_questions, ->{ order(:question_order)},
        :foreign_key=>:gid,
        :primary_key=>:gid, :inverse_of=>:lime_group
    rails_admin do
        navigation_label "Lime Survey"
    end

    def parent_questions
        @parent_questions ||= lime_questions.select{|question|question.parent_qid.to_i==0}.sort_by!{|question|question.question_order}
    end

    def contains_visible_questions?
        @contains_visible_questions ||= parent_questions.any?{|question| question.hidden? == false}
    end
end

