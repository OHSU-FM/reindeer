module Assignment
  class SurveyAssignment < ActiveRecord::Base

    belongs_to :lime_survey, :primary_key=>:sid, :foreign_key=>:lime_survey_sid, :inverse_of=>:survey_assignments
    belongs_to :assignment_group

    has_many :user_assignments, :inverse_of=>:survey_assignment, :dependent=>:delete_all

    validates :assignment_group, presence: true
    validates :lime_survey,
      presence: true,
      if: Proc.new { |f| f.assignment_group.present? }
    validates :title,
      presence: true,
      if: Proc.new {|f| f.lime_survey_sid.present?}

    accepts_nested_attributes_for :user_assignments, :allow_destroy=>true, :reject_if=>:all_blank

    before_validation :do_default_title
    after_validation :do_gather_user_tokens

    rails_admin do
      field :title do
        required false
        help "Defaults to LimeSurvey.title"
      end
      field :assignment_group
      field :lime_survey do
        associated_collection_cache_all false
        associated_collection_scope do
          sas = bindings[:object]
          Proc.new { |scope|
            if sas
              if sas.assignment_group.present?
                sas.assignment_group.lime_surveys
              end
            else
              LimeSurvey.all
            end
          }
        end
      end
      field :gather_user_tokens, :boolean
      field :as_inline, :boolean do
        help 'Show inline form for assignment'
      end
      edit do
        field :gather_user_tokens do
          help 'Scan "users" table for email addresses that are present in the tokens table for this survey.'
          read_only do
            bindings[:object].new_record?
          end
        end
      end
    end

    def lime_survey_enum
      assignment_group.present? ? assignment_group.lime_surveys : []
    end

    ##
    # Set the default title if one is not set during update
    def do_default_title
      if title.blank? && lime_survey_sid.present?
        self[:title] = lime_survey.title
      end
    end

    ##
    # Add user_assignments to all users that have a token for this survey
    def do_gather_user_tokens

      # Only do this if gather_user_tokens is truthy
      return unless gather_user_tokens == '1'

      ActiveRecord::Base.transaction do

        unless user_assignments.empty?
          # gather old comments for transfer to new assignments
          comment_hash = {}
          user_assignments.each do |ua|
            ua.user_responses.each do |ur|
              next if !ur.has_comments? || !ur.present?
              ur.comments.each do |c|
                comment_hash[[ur.title, ur.category, ur.status]] = c.id
              end
            end
          end
        end
        # Remove all old assignments
        user_assignments.each{|ua| ua.destroy }

        unless lime_survey_sid
          errors.add(:lime_survey_sid, 'No lime survey selected')
          return
        end

        tid_emails = lime_survey.lime_tokens.pluck :tid, :email
        unless tid_emails
          errors.add(:gather_user_tokens, 'No tokens to add')
          return
        end

        ag_emails = assignment_group.users.map{|u| u.email}
        filtered_tids = tid_emails.select{|tid, email| ag_emails.include? email}
        filtered_tids.each do |tid, email|
          user = User.find_by(email: email)
          next if user.nil?
          ua = user_assignments.build
          ua.lime_token_tid = tid
          ua.user_id = user.id
          ua.save!
          ua.user_responses
        end

        if !comment_hash.nil? && !comment_hash.empty?
          # rebuild comment relationships
          comment_hash.each do |k, v|
            c = Comment.find(v)
            new_id = Assignment::UserResponse.find_by(title: k[0],
                                                      category: k[1],
                                                      status: k[2]).id
            c.commentable_id = new_id
          end
        end
      end
    end

    def survey_data_sid_and_gid
      lg = lime_survey.lime_groups.where(group_name: "SurveyData").first
      [lg.sid, lg.gid] unless lg.nil?
    end

    def survey_data_questions_key
      key = {}
      sid, gid = survey_data_sid_and_gid
      lqs = LimeQuestion.where(sid: sid, gid: gid)
      lqs.each do |lq|
        key["#{lq.sid}X#{lq.gid}X#{lq.qid}"] = lq.title
      end
      key
    end

    def gather_user_tokens
      @gather_user_tokens
    end

    def gather_user_tokens= val
      @gather_user_tokens = val
    end
  end

end
