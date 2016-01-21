class PermissionLsGroupFilter < ActiveRecord::Base
    belongs_to :permission_ls_group, :inverse_of=>:permission_ls_group_filters
    belongs_to :lime_question, :primary_key=>:qid, :foreign_key=>:lime_question_qid, :inverse_of=>:permission_ls_group_filters

    validates_presence_of :permission_ls_group
    validates_presence_of :ident_type, :if=>Proc.new {|obj|obj.restricted_val.to_s.empty?}
    validates_presence_of :restricted_val, :if=>Proc.new {|obj| obj.ident_type.to_s.empty?}

    attr_accessible :permission_ls_group_id, :lime_question_qid, :ident_type, :restricted_val, :filter_all
    before_validation :check_ident_and_val

    rails_admin do
        navigation_label "Permissions"

        field :filter_all
        field :ident_type, :string do
            required false
        end
        field :restricted_val, :string do
            required false
        end
        field :lime_question do
            associated_collection_cache_all false
            associated_collection_scope do
                plgk = bindings[:object]
                Proc.new { |scope|
                    if plgk.present?
                        qids = plgk.permission_ls_group.lime_survey.lime_questions.map{|pq|pq.qid}
                        scope = scope.where('qid in (?)', qids) if plgk.present?
                    end
                }
            end
        end

    end

    def ident_type_enum
        UserExternal.uniq.pluck(:ident_type)
    end

    def check_ident_and_val
        self.restricted_val = nil unless self.ident_type.to_s.empty?
        self.ident_type = nil unless self.restricted_val.to_s.empty?
    end

    def user_externals
        if ident_type.present?
            @user_externals ||= UserExternal.where(:ident_type=>ident_type)
        else
            []
        end
    end

    def enabled?
        (ident_type.present? || restricted_val.present?) && lime_question.present?
    end

    def title
        enabled? ? "#{lime_question.question}(=#{filter_val})" : "(disabled)"
    end

    def filter_val
        ident_type.present? ? ident_type : restricted_val.to_s
    end
end


