class Assignment::UserAssignment < ActiveRecord::Base
  attr_accessible :user_id, :survey_assignment_id, :lime_token_tid
  belongs_to :user
  belongs_to :survey_assignment
  has_one :lime_survey, :through=>:survey_assignment
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
  def completed; token_data[:completed] == 'Y'; end       # String: raw completed val
  def completed?; completed; end# Binary: completed val
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

end
