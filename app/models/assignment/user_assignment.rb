class Assignment::UserAssignment < ActiveRecord::Base
  include ModelUtils

  belongs_to :user
  belongs_to :survey_assignment
  has_one :lime_survey, through: :survey_assignment
  has_many :user_responses, dependent: :destroy
  has_many :lime_groups, through: :lime_survey
  has_many :lime_questions, through: :lime_groups
  validates_presence_of :lime_survey
  validates_presence_of :token
  validates_presence_of :user

  rails_admin do
    edit do
      field :user do
        inline_add false
      end
      field :survey_assignment
      field :token do
        read_only true
      end
    end

    list do
      field :id
      field :lime_survey
      field :user do
        inline_add false
      end
      field :assignment_group do
        formatted_value do
          value.title
        end
      end
      field :token do
        read_only true
      end

      field :url do
        pretty_value do
          if bindings[:object] && bindings[:object].token.present?
            bindings[:view].link_to('', bindings[:object].url, class: 'fa fa-external-link', target: '_blank')
          end
        end
      end

    end
  end

  def token_attrs; lime_survey.token_attrs; end           # Hash: Attribute names
  def lime_tokens; lime_survey.lime_tokens; end           # String: Alias token object
  def lang; token_data[:language]; end                    # String: language of response
  def token; token_data[:token]; end                      # String: token of survey
  def sid; lime_survey.sid; end                           # Int: sid of survey
  def completed; token_data[:completed] != "N"; end       # String: raw completed val
  def completed?; completed; end                          # Binary: completed val
  def new_url; "#{url}/newtest/Y"; end                    # String: URL of new survey
  def started?; response_data.present?; end               # Binary: Has survey response started?
  def uses_left?; token_data[:usesleft].to_i > 0; end
  def editable?; lime_survey.alloweditaftercompletion == 'Y'; end
  def multiple?; editable? && !persist?; end
  def persist?; lime_survey.tokenanswerspersistence == 'Y'; end

  ##
  # base URL of survey
  def url
    "#{Settings.lime_url}/index.php/survey/index/sid/#{sid}/token/#{token}/lang/#{lang}"
  end

  def auto_url
    started? ? url : new_url
  end

  ##
  # returns {} of token table data
  def token_data
    @token_data ||= HashWithIndifferentAccess.new(
      lime_tokens.add_filter(:tid, lime_token_tid).dataset.first || {}
    )
  rescue
    {}
  end

  # returns {} of response table data
  def response_data
    @response_data ||= response_data_mult.first || []
  end

  # returns {} of response table data if multiple?
  def response_data_mult
    @response_data_mult ||= survey_assignment.
      lime_survey.lime_data.add_filter(:token, token).dataset.select{ |h|
      h["submitdate"].present? } || {}
  end

  def status_str
    return 'new form ' if multiple?
    return 'edit' if editable?
    return 'complete' if completed?
    return 'started' if started?
    'not started'
  end

  def assignment_group
    survey_assignment.assignment_group
  end

  def ag_owner
    assignment_group.owner
  end

  def group_and_title
    survey_assignment.lime_survey.group_and_title_name
  end

  def lime_groups
    survey_assignment.lime_survey.lime_groups
  end

  def get_meta_attribute attr
    data_key = survey_assignment.survey_data_questions_key
    response_data.each do |k, v|
      if data_key[k] == attr.to_s
        return v
      end
    end
    ""
  end

  def survey_type
    @survey_type ||= get_meta_attribute "SurveyType"
  end

  def status_question
    @status_question ||= get_meta_attribute "StatusQuestion"
  end

  def status_lime_question
    lime_questions.select{|lq| lq.title.include? status_question}.first
  end

  # true if user_assignment has only one user_response
  def is_shallow?
    user_responses.count == 1 ? true : false
  end

  # { cat => [urs], cat => [urs] }. n is the number of dates back to include
  def ur_categories n=1
    hash = {}
    user_responses.map{ |ur| ur.category }.uniq.each do |category|
      hash[category] = Hash.new {|h, k| h[k] = []}
      urs = Assignment::UserResponse.where(user_assignment: self,
                                                  category: category)
      urs.order(submitdate: "desc").map{|ur| ur.submitdate }.uniq.first(n)
        .map{|d| hash[category] = urs.where(submitdate: d) }
    end
    hash
  end

  def ur_dates
    user_responses.order(submitdate: "desc").map {|ur| ur.submitdate }.uniq
  end

  def ur_categories_by date
    hash = {}
    user_responses.map{ |ur| ur.category }.uniq.each do |category|
      urs = Assignment::UserResponse.where(user_assignment: self,
                                                      category: category,
                                                      submitdate: date)
      hash[category] = urs unless urs.empty?
    end
    hash
  end

  # returns hash of lime answer code => status text for a lime_question
  def status_hash lq
    if lq
      Hash[lq.lime_answers.map {|la| [la.code, la.answer] }]
    else
      {}
    end
  end

  def user_responses
    if multiple? # user could have left new responses since we last checked
      check_for_new_responses
    elsif completed? # lime_survey is not persisted, so response_data.count == 1
      if Assignment::UserResponse.where(user_assignment: self).empty?
        build_user_responses
      else
        Assignment::UserResponse.where(user_assignment: self)
      end
    else
      []
    end
  end

  def check_for_new_responses
    resps = Assignment::UserResponse.where(user_assignment: self)
    if !resps.empty?
      max = resps.max_by{|ur| ur.updated_at}.updated_at
      new = response_data_mult.select{|d| d["submitdate"].to_time > max }
      if new.count > 0
        new.each do |r|
          build_user_responses r
        end
      else
        return resps
      end
    elsif resps.empty?
      response_data_mult.each {|r|
        build_user_responses r
      }
    end
    Assignment::UserResponse.where(user_assignment: self)
  end

  private

  def build_user_responses resp = nil
    resp ||= response_data
    g_title, ra_title = group_and_title
    submitdate = resp["submitdate"]
    create_list = []
    gathered_responses(resp).each do |category, loh|
      loh.each do |h|
        next if h.all? {|k,v| v.blank? }
        new_h = { "resp_type"          => ra_title,
                  "category"           => category,
                  "submitdate"         => submitdate,
                  "user_assignment_id" => self.id
        }.merge(h)
        Assignment::UserResponse.new.populate_from_hash(new_h).save!
      end
    end
    Assignment::UserResponse.where(user_assignment: self)
  end

  # generates hash of hashes where each subhash will be a user_response
  def gathered_responses resp = nil
    h = Hash.new
    lime_groups.each do |lg|
      if lg.contains_visible_questions?
        group_name = lg.group_name.to_s
        h[group_name] = []
        lg.lime_questions.each do |lq|
          q_list = []
          if lq.has_sq?
            lq.sub_questions.each do |sq|
              row = Hash.new
              value = resp["#{lq.sid}X#{lq.gid}X#{lq.qid.to_s + sq.title}"]
              unless value.blank?
                if lq.title.include? status_question
                  row.merge!(Hash[lq.title, status_hash(lq)[value]])
                else
                  row.merge!(Hash[lq.title, value])
                end
              end
              q_list << strip_hash_values!(row) unless row.empty?
            end
          else
            row = Hash.new
            value = resp["#{lq.sid}X#{lq.gid}X#{lq.qid}"]
            unless value.blank?
              if lq.title.include? status_question
                row.merge!(Hash[lq.title, status_hash(lq)[value]])
              else
                row.merge!(Hash[lq.title, value])
              end
            end
            q_list << strip_hash_values!(row) unless row.empty?
          end
          h[group_name] << q_list unless q_list.empty?
        end
        h[group_name] = h[group_name].transpose.collect{|e| e.inject(&:merge)}
      end
    end
    h
  end
end
