require 'php_serialize'

class LimeSurvey < ActiveRecord::Base

    CONFIG_GROUP_CODE   = 'ReindeerConfig'
    QRESPONSE_STATUS_CODE = 'responseStatus'

    include EdnaConsole

    self.inheritance_column = nil
    self.primary_key = :sid
    has_many :permission_ls_groups, :foreign_key=>:lime_survey_sid, :inverse_of=>:lime_survey
    has_many :lime_groups, -> {order 'lime_groups.group_order'}, :foreign_key=>:sid, :inverse_of=>:lime_survey
    #has_many :lime_questions, :through=>:lime_groups
    has_many :lime_surveys_languagesettings, :foreign_key=>:surveyls_survey_id
    has_one :role_aggregate, :foreign_key=>:lime_survey_sid, :inverse_of=>:lime_survey
    delegate :add_filter, :dataset, :to=>:lime_data
    has_many :survey_assignments, :foreign_key=>:lime_survey_sid, :inverse_of=>:lime_survey
    scope :active, -> { where(active: 'Y') }
    scope :with_role_aggregate, -> { joins(:role_aggregate) }
    # TODO: Double check to see if with_data_table is the same as "active"
    scope :with_data_table, -> {
      match = ActiveRecord::Base.connection.tables.join(' ').scan(/#{table_name.singularize}_(\d+)/)
      match.present? ? where(['sid in (?)', match.flatten]) : none
    }

    rails_admin do
        navigation_label "Lime Survey"
        list do
          field :sid
          field :admin
          field :title
          field :role_aggregate
          field :lime_config_link do
            pretty_value do
              bindings[:view].link_to('', bindings[:object].lime_config_link, class: 'fa fa-external-link', target: '_blank')
            end
          end
        end
    end

    ##
    # Description of token attributes
    def token_attrs
      return @token_attrs if defined? @token_attrs
      attr_data = attributedescriptions.to_s
      if (attributedescriptions.to_s =~ /^a:\d+:\{/).nil?
        @token_attrs = HashWithIndifferentAccess.new(
          YAML.load(attr_data)
        )
      else
        @token_attrs = HashWithIndifferentAccess.new(
          PHP.unserialize(attr_data)
        )
      end
      @token_attrs = {} unless @token_attrs.is_a? Hash
      @token_attrs
    end

    def parent_questions
        @parent_questions ||= lime_groups.map{|group|group.parent_questions}.flatten
    end

    def lime_questions
        @lime_questions ||= lime_groups.map{|lg|lg.lime_questions}.flatten
    end

    def completed_surveys_count
        @completed_surveys_count ||= dataset.count{|row|!row['submitdate'].nil?}
    end

    def started_surveys_count
        return @started_surveys_count if defined? @started_surveys_count
        if lime_data.column_names.include?('startdate')
            @started_surveys_count = dataset.count{|row|!row['startdate'].nil?}
        else
            @started_surveys_count = nil
        end
        return @started_surveys_count
    end

    def response_percent
        @response_percent ||= (completed_surveys_count.to_f / response_count) * 100
    end

    def response_count
        dataset.count
    end

    def last_updated
        return @last_updated if defined? @last_updated
        max_row = dataset.max_by{|row|row['submitdate'].to_s}
        if max_row
            @last_updated = max_row['submitdate']
        else
            @last_updated = nil
        end
        return @last_updated
    end
    ##
    # Column Names Enumerator
    # TODO: This is broken, it does not return appropriate column_name when
    #       column has a suffix
    def column_names
        return [] unless sid
        return @column_names if defined? @column_names
        @column_names = []
        lime_groups.each do |lgroup|
            lgroup.lime_questions.each do |lquestion|
                @column_names.push [lquestion.title, lquestion.my_column_name]
            end
        end
        return @column_names
    end

    ##
    # RailsAdmin label
    def title
        settings = lime_surveys_languagesettings.first
        settings.nil? ? 'New' : settings.surveyls_title
    end

    def status_questions
        return @status_questions if defined? @status_questions
        group = lime_groups.find{|group|group.group_name == CONFIG_GROUP_CODE}
        return [] if group.nil?
        pquestion = group.parent_questions.find{|pquestion|pquestion.title==QRESPONSE_STATUS_CODE}
        return [] if pquestion.nil?
        @status_questions = pquestion.sub_questions
    end

    def find_question key, val
        lime_groups.each do |group|
            group.lime_questions.each do |question|
                return question if question.send(key) == val
            end
        end
        return nil
    end

    def wipe_response_sets
        lime_questions.each{|lq|lq.wipe_response_set}
        return nil
    end

    def group_and_title_name
        # Generate a title to go with each of them
        title1, title2 = title.split(':', 2)
        g_title, ra_title = title2.nil? ? ['', title1] : [title1, title2]
        return g_title, ra_title
    end

    ##
    # Instantiate a lime_stat object if one does not already exist
    def lime_stats(opts={})
        @lime_stats ||= ::LimeExt::LimeStat::LimeStat.new(self)
    end

    ##
    # Instantiate a lime_data object if one does not already exist
    def lime_data
        raise 'sid not set' if not(sid)
        @lime_data ||= ::LimeExt::LimeData.new(self)
    end

    ##
    # Instantiate a lime_data object if one does not already exist
    def lime_tokens
        raise 'sid not set' if not(sid)
        @lime_tokens ||= ::LimeExt::LimeTokens.new(self)
    end

    def lime_config_link
      "#{Settings.lime_url}/admin/survey/sa/view/surveyid/#{sid}"
    end

end

