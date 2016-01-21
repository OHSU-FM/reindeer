class RoleAggregate < ActiveRecord::Base
    has_paper_trail
    attr_accessible :lime_survey_sid, :agg_fieldname, :agg_label, :agg_title_fieldname,
        :pk_fieldname, :pk_title_fieldname, :pk_label, :default_view, :managed_permissions

    attr_reader :questions
    attr_accessor :agg, :pk

    ##
    # Associations
    belongs_to :lime_survey, :primary_key=>:sid, :foreign_key=>:lime_survey_sid, :inverse_of=>:role_aggregate
    has_many :question_widgets

    ##
    # Validations
    validates_presence_of :default_view, :lime_survey_sid, :lime_survey
    validate :validates_table_existance

    before_validation :set_default_view
    before_destroy :delete_dash_widgets

    DEFAULT_VIEWS = ['graph', 'filter', 'spreadsheet']

    def data_table_exists?
      lime_data.table_exists?
    end

    rails_admin do
        navigation_label 'Lime Survey'
        list do
            field :lime_survey
            field :created_at
            field :updated_at
        end
        edit do

            field :lime_survey_sid, :enum do
                #inline_edit false
                #inline_add false
                enum do
                  LimeSurvey.with_data_table.map{|ls|[ls.title, ls.sid]}
                end
            end
            field :ready_for_use? do
                read_only true
            end

            group 'Primary Filter' do
                field :pk_label
                field :pk_fieldname, :enum
                field :pk_title_fieldname, :enum
            end

            group 'Aggregate Filter' do
                field :agg_label
                field :agg_fieldname, :enum
                field :agg_title_fieldname, :enum
            end

            group 'View' do
                field :default_view
            end
        end

    end

    def ready_for_use?
        agg_question.present? && pk_question.present? && data_table_exists?
    end

    def delete_dash_widgets
        question_widgets.each{|qw| qw.dash_widget.destroy}
    end


    def validates_table_existance
        # Checks for existence of lime_survey table before saving
        unless data_table_exists?
            errors.add :lime_survey, 'results table does not exist'
        end
    end

    ###
    ## Set default_view if not already set
    def set_default_view
        if self[:default_view].to_s.empty?
            self[:default_view] = default_view_enum.first
        end
    end

    ##
    # return a view type even if one is not set
    def default_view
        if self[:default_view].to_s.empty? || !default_view_enum.include?(self[:default_view])
            self[:default_view] = default_view_enum.first
        end
        return self[:default_view]
    end

    ##
    # Enumerator for different view types
    def default_view_enum
        DEFAULT_VIEWS
    end

    ##
    # Aliases
    def lime_stats
        lime_survey.lime_stats
    end

    def lime_data
        lime_survey.lime_data
    end

    def dataset
        lime_data.dataset
    end

    ##
    # Array of questions and their associated Answers
    #   - We had to store it this way because we need to register the dataset with the answers
    #   - The objects are garbage collected and forgotten if we register on the fly
    #   - So we store a copy of the answers here so they can be registered and remembered
    def qa_buffer
        Rails.logger.warn('qa_buffer is deprecated should not be required or used')
        return @qa_buffer if defined? @qa_buffer
        @qa_buffer = []
        lime_survey.lime_groups.each do |lgroup|
            lgroup.lime_questions.each do |lquestion|
                @qa_buffer.push [lquestion, lquestion.lime_answers]
            end
        end
        return @qa_buffer
    end

    ##
    # Alias for buffered questions
    def questions
        @questions ||= qa_buffer.map{|qq|qq.first}
    end

    ##
    # Alias for buffered answers
    def answers
        @answers ||= qa_buffer.map{|qq|qq.last}.flatten
    end


    ##
    # List all emails that are in dataset
    def pk_enum
        return [] unless pk_fieldname
        @pk_enum ||= valid_enum_options(pk_question, pk_title_question)
    end

    ##
    # List all emails that are in dataset
    def agg_enum
        return [] unless agg_question
        @agg_enum ||= valid_enum_options(agg_question, agg_title_question)
    end

    ##
    # Val needs to be
    #

    ##
    # Generate an enum w/ options for the two questions
    # - Replace qtitle with qval if qtitle missing information
    def valid_enum_options qval, qtitle
        ##
        # Important: We are using the response_set so that the values are properly formatted

        return [] if qval.nil?

        # DO NOT CALL response_set on a question, if filters are added later they
        # will not be accounted for
        qval_rs = LimeExt::ResponseLoaders.responses_for qval
        return [] if (qval_rs.nil? || qval_rs.data.blank?)
        qtitle_rs = LimeExt::ResponseLoaders.responses_for qtitle

        # Swap out qtitle if missing information
        if qtitle.nil? || qtitle_rs.nil? || qtitle_rs.data.empty?
            qtitle = qval
            qtitle_rs = qval_rs
        end

        # get data
        val_data = qval_rs.related_data.first[1]
        title_data = qtitle_rs.data

        # Pair title data with value data
        # [1,2,3].zip([4,5,6]) = [ [1,4][2,5][3,6] ]
        result = title_data.zip(val_data)
        # Use only values that have a title and a value
        # Unique and sort then return
        return result.select{|x,y|!(x.to_s.empty? || y.to_s.empty?)}.uniq.sort_by{|arr|arr.to_s}
    end

    ##
    # Find question specified by fieldname
    def pk_question
        return nil unless pk_fieldname
        @pk_question = lime_survey.find_question :my_column_name, pk_fieldname
    end

    ##
    # Find question specified by fieldname
    def pk_title_question
        return nil unless pk_title_fieldname
        @pk_title_question = lime_survey.find_question :my_column_name, pk_title_fieldname
    end

    ##
    # Find question specified by fieldname
    def agg_question
        return nil unless agg_fieldname
        @agg_question = lime_survey.find_question :my_column_name, agg_fieldname
    end

    ##
    # Find question specified by fieldname
    def agg_title_question
        return nil unless agg_title_fieldname
        @agg_title_question = lime_survey.find_question :my_column_name, agg_title_fieldname
    end

    ##
    # Return an array of valid options for agg_fieldname attribute
    def agg_fieldname_enum
        return [] unless lime_survey
        return enum_column_names || []
    end

    ##
    # Return an array of valid options for agg_title_fieldname attribute
    def agg_title_fieldname_enum
        return [] unless lime_survey
        return enum_column_names || []
    end

    ##
    # Return an array of valid options for pk_fieldname attribute
    def pk_fieldname_enum
        return [] unless lime_survey
        return enum_column_names || []
    end

    ##
    # Return an array of valid options for pk_title_fieldname_fieldname attribute
    def pk_title_fieldname_enum
        return [] unless lime_survey
        return enum_column_names || []
    end

    ##
    #   Use pk_label if defined or the code for pk_fieldname if not defined
    def get_pk_label
        return '' if pk_fieldname.to_s.empty?
        @get_pk_label ||= pk_label.to_s.empty? ? find_fieldname_str(pk_fieldname) : pk_label
    end

    ##
    #   Use agg_label if defined or the code for agg_fieldname if not defined
    def get_agg_label
        return '' if agg_fieldname.to_s.empty?
        @get_agg_label ||= agg_label.to_s.empty? ? find_fieldname_str(agg_fieldname) : agg_label
    end

    ##
    # Convert column name to code name
    def find_fieldname_str fieldname
        enum_column_names.find{|key, val|val==fieldname}.first
    end

    ##
    # RailsAdmin label
    def name
        lime_survey.nil? ? 'New' : lime_survey.title
    end

    private
    def enum_column_names
        bad_cols = lime_survey.status_questions.map{|sq|sq.my_column_name}.to_set
        lime_survey.column_names.select{|title, col_name|!bad_cols.include?(col_name)}
    end

end
