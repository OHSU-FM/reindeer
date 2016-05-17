class Assignment::UserAssignment < ActiveRecord::Base
  attr_accessible :user_id, :survey_assignment_id, :lime_token_tid
  belongs_to :user
  belongs_to :survey_assignment
  has_one :lime_survey, :through=>:survey_assignment
  has_many :user_responses
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

  ##
  # returns {} of response table data
  def response_data
    @response_data ||= survey_assignment.
      lime_survey.lime_data.add_filter(:token, token).dataset.first || {}
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
    @survey_type ||= get_meta_attribute("SurveyType")
  end

  def status_question
    @status_question ||= get_meta_attribute "StatusQuestion"
  end

  # true if user_assignment has only one user_response
  def is_shallow?
    user_responses # have to call this first or it comes through nil
    user_responses.count > 1 ? false : true
  end

  def ur_categories
    hash = {}
    user_responses.map{ |ur| ur.category }.uniq.each do |category|
      hash[category] = Assignment::UserResponse.where(user_assignment: self, category: category)
    end
    return hash
  end

  # returns hash of lime answer code => status text for a user_assignment
  def status_hash
    return @status_hash if defined? @status_hash

    lq = LimeQuestion.where(sid: sid, title: status_question).first
    @status_hash = Hash[lq.lime_answers.map {|la| [la.code, la.answer] }]
    return @status_hash
  end

  def user_responses
    if completed?
      if Assignment::UserResponse.where(user_assignment: self).empty?
        build_user_responses
      else
        Assignment::UserResponse.where(user_assignment: self)
      end
    else
      []
    end
  end

  def build_user_responses
    g_title, ra_title = group_and_title
    resps = gathered_responses.dup
    create_list= []
    resps.each do |category, lol|
      lol.each do |list|
        create_list<< [g_title, ra_title, category, *list]
      end
    end
    # have to iterate twice bc create fails otherwise for some reason
    create_list.each do |f|
      resp_type = f.shift()
      ra_title = f.shift()
      category = f.shift()
      status = f.pop()
      content = f.pop()
      title = f.pop() || ra_title
      Assignment::UserResponse.create(
        resp_type: resp_type,
        category: category,
        title: title,
        content: content,
        status: status,
        user_assignment_id: id
      )
    end
  end

  # generates row for each valid line of user_assignment.response_data
  def gathered_responses
    h = Hash.new
    lime_groups.each do |lg|
      if lg.contains_visible_questions?
        group_name = lg.group_name.to_s
        h[group_name] = []
        lg.lime_questions.each do |lq|
          row = []
          response_key = "#{lg.sid}X#{lg.gid}X#{lq.qid}"
          response_data.each do |key, value|
            if key.include? response_key
              if status_hash.keys.include? value
                row << status_hash[value].to_s
              else
                row << value unless value.blank?
              end
            end
          end
          h[group_name] << row unless row.empty?
        end
        h[group_name] = h[group_name].transpose
      end
    end
    h
  end

end
