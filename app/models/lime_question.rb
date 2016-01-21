class LimeQuestion < ActiveRecord::Base
    ##
    # Question types used by LimeSurvey and the short names we use for partials
    QTYPES = {
        '1'=>'dual_arr',          # - Array (Flexible Labels) Dual Scale
        '5'=>'five_point',        # - 5 Point Choice
        'A'=>'arr_five',          # - Array (5 Point Choice)
        'B'=>'arr_ten',           # - Array (10 Point Choice)
        'C'=>'arr_ynu',           # - Array (Yes/No/Uncertain)
        'D'=>'date',              # - Date
        'E'=>'arr_isd',           # - Array (Increase, Same, Decrease)
        'F'=>'arr_flex',          # - Array (Flexible Labels)
        'G'=>'gender',            # - Gender
        'H'=>'arr_flex_col',      # - Array (Flexible Labels) by Column
        'I'=>'lang',              # - Language Switch
        'K'=>'mult_numeric',      # - Multiple Numerical Input
        'L'=>'list_radio',        # - List (Radio)
        'M'=>'mult',              # - Multiple choice
        'N'=>'numeric',           # - Numerical Input
        'O'=>'list_comment',      # - List With Comment
        'P'=>'mult_w_comments',   # - Multiple choice with comments
        'Q'=>'mult_short_text',   # - Multiple Short Text
        'R'=>'rank',              # - Ranking
        'S'=>'short_text',        # - Short Free Text
        'T'=>'long_text',         # - Long Free Text
        'U'=>'huge_text',         # - Huge Free Text
        'X'=>'boiler',            # - Boilerplate Question
        'Y'=>'yes_no',            # - Yes/No
        '!'=>'list_drop',         # - List (Dropdown)
        ':'=>'arr_mult_drop',     # - Array (Flexible Labels) multiple drop down
        ';'=>'arr_mult_text',     # - Array (Flexible Labels) multiple texts
        '|'=>'file_upload'        # - File Upload Question
    }

    default_scope { order('question_order ASC') }
    self.inheritance_column = nil
    self.primary_key = :qid


    #belongs_to :parent_question
    belongs_to :lime_group, :primary_key=> "gid", :foreign_key=> "gid", :inverse_of=>:lime_questions
    has_many :lime_answers, :primary_key=> "qid", :foreign_key=> "qid", :inverse_of=>:lime_question
    #has_many :role_aggregates, :foreign_key=>:lime_survey_sid#, :inverse_of=>:role_aggregates
    has_many :lime_question_attributes, :foreign_key=>:qid, :inverse_of=>:lime_question
    has_many :permission_ls_group_filters, :inverse_of=>:lime_question, primary_key: :qid, foreign_key: :lime_question_qid

    rails_admin do
        navigation_label "Lime Survey"
        field :qtype
        field :parent_qid do
            pretty_value do
                obj = bindings[:object]
                if obj.parent_qid.to_i > 0
                    value = obj.parent_question.name.html_safe
                    view = bindings[:view]
                    url =  view.show_path( model_name: 'lime_question', id: obj.parent_qid)
                    view.tag(:a, { :href => url}) << value
                else
                    obj.parent_qid
                end
            end
        end
        include_all_fields
    end

    def lime_survey
        lime_group.lime_survey
    end

    def dataset
        lime_survey.lime_data.dataset
    end

    def lime_stats
        lime_survey.lime_stats
    end

    def lime_data
        lime_survey.lime_data
    end

    #################################################################
    ## Get attributes possibly from cache                           #
    #def lime_question_attributes                                   #
    #    return [] if qid.to_s.empty?                               #
    #    return @lime_question_attributes if defined? @lime_question_attributes
    #    @lime_question_attributes = get_lq_attributes              #
    #end                                                            #
    #                                                               #
    #                                                            #  #
    #                                                           #   #
    ###                                                        ######
    ## Get attributes in database for this question             #
    #def get_lq_attributes                                       #
    #    result = HashWithIndifferentAccess.new
    #    attrs = ActiveRecord::Base.connection.execute("SELECT attribute, value FROM #{self.class.table_name.singularize}_attributes where qid=#{qid}").to_a
    #    attrs.each do |attr|
    #        result[attr['attribute']] = attr['value']
    #    end
    #    return result
    #end

    def qattrs
        return @qattrs if defined? @qattrs
        @qattrs = HashWithIndifferentAccess.new
        lime_question_attributes.each do |qa|
            @qattrs[qa.xattribute] = qa.value
        end
        return @qattrs
    end

    ##
    # Should this question be visible?
    def hidden?
        qattrs[:hidden] == '1'
    end

    def num_value_int_only?
       qattrs[:num_value_int_only] == '1'
    end

    ##
    # convert type to qtype given (used for partials)
    def qtype
        (parent_qid.to_i == 0) ? QTYPES[type] : "#{QTYPES[type]}_child"
    end

    def is_sq?
        self.parent_qid > 0
    end

    def has_sq?
        sub_questions.count > 0
    end

    def answers
        return parent_question.lime_answers if is_sq?
        return self.lime_answers
    end

    ##
    # TODO: This is likely buggy, questions with default answers might break this
    def my_column_name
        return @my_column_name if defined? @my_column_name
        if is_sq?
            @my_column_name = "#{lime_group.sid}X#{gid}X#{parent_qid}#{title}"
        else
            @my_column_name = "#{lime_group.sid}X#{gid}X#{qid}"
        end
        return @my_column_name
    end

       ##
    # Find all of our sub questions
    def sub_questions
        @sub_questions ||= lime_group.lime_questions.select{|question|question.parent_qid == qid}
    end

    ##
    # Find our parent question
    def parent_question
        return nil unless is_sq?
        @parent_question ||= lime_group.lime_questions.find{|question|question.qid==parent_qid}
    end

    ###
    # Text to show as identifier in rails_admin
    def name
        title
    end

    ##
    # Generate statistics
    def stats
        return @stats if defined? @stats
        if is_sq?
            @stats = parent_question.stats.sub_stats.find{|sub_stat|sub_stat.question.qid == qid}
        else
            @stats ||= lime_survey.lime_stats.generate_stats_for_question self
        end
        return @stats
    end

    ##
    # Get the response_set for this question
    def response_set
        if defined?(@response_set)
            return @response_set unless wipe_response_set?
        end
        @wipe_response_set = false
        @response_set =  LimeExt::ResponseLoaders.responses_for self
        return @response_set
    end

    def wipe_response_set
        @wipe_response_set = true
    end

    def wipe_response_set?
        return @wipe_response_set || false
    end

end
