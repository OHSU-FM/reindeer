class Assignment::SurveyAssignment < ActiveRecord::Base
    attr_accessible :lime_survey_sid, :title, :gather_user_tokens, :user_assignments_attributes, :as_inline
    attr_accessor :gather_user_tokens

    belongs_to :lime_survey, :primary_key=>:sid, :foreign_key=>:lime_survey_sid, :inverse_of=>:survey_assignments

    has_many :user_assignments, :inverse_of=>:survey_assignment, :dependent=>:delete_all
    
    validates_presence_of :lime_survey_sid
    validates_presence_of :title, :if=> Proc.new {|f| f.lime_survey_sid.present?}

    accepts_nested_attributes_for :user_assignments, :allow_destroy=>true, :reject_if=>:all_blank

    before_validation :do_default_title
    after_validation :do_gather_user_tokens

    rails_admin do
        navigation_label "User Content"
        field :title do
            required false
        end
        field :lime_survey
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
        
        # Remove all old assignments
        user_assignments.delete_all

        unless lime_survey_sid
          errors.add(:lime_survey_sid, 'No lime survey selected')
          return
        end
        
        #  
        tid_emails = lime_survey.lime_tokens.pluck :tid, :email
        unless tid_emails
          errors.add(:gather_user_tokens, 'No tokens to add')
          return
        end
        
        emails = tid_emails.map{|tid, email| email}
        users = User.where(['email in (?)', emails])
        tid_emails.each do |tid, email|
          user = users.find{|uu|uu.email == email}
          next if user.nil?
          ua = user_assignments.build
          ua.lime_token_tid = tid
          ua.user_id = user.id
          ua.save!
        end
      end
    end

end

