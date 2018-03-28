module LimeExt::ResponseLoaders
  def self.responses_for question
    # If sq check with parent and get response_set for ourselves
    if question.is_sq?
      parent_set = question.parent_question.response_set
      # if empty or nil then return nil
      if parent_set.data.nil? || parent_set.data.empty?
        return nil
      end
      # if it responds to :data then we can assume it is a response_set
      if parent_set.data.first.respond_to? :data
        return parent_set.data.find{|rs| rs.qid == question.qid }
      end
      # Nothing to return
      return nil
    else
      # Otherwise just create our own
      loader_method_name = "#{question.qtype}"
      if Loaders.respond_to? loader_method_name
        return Loaders.send(loader_method_name, question)
      elsif question.has_sq?
        return ResponseSets::ResponseSetGenericParent.new question
      else
        return ResponseSets::ResponseSetGeneric.new question
      end
    end
  end

  module Loaders

    def self.file_upload pquestion
      return ResponseSets::ResponseSetFileUpload.new pquestion
    end

    def self.mult_short_text pquestion
      return ResponseSets::ResponseSetMultText.new pquestion
    end

    def self.mult pquestion
      return ResponseSets::ResponseSetMult.new pquestion
    end

    def self.mult_w_comments pquestion
      return ResponseSets::ResponseSetMultComment.new pquestion
    end

    def self.yes_no pquestion
      return ResponseSets::ResponseSetYesNo.new pquestion
    end

    def self.gender pquestion
      return ResponseSets::ResponseSetGender.new pquestion
    end

    def self.mult_numeric pquestion
      return ResponseSets::ResponseSetMultNumeric.new pquestion
    end

    def self.numeric pquestion
      return ResponseSets::ResponseSetNumeric.new pquestion
    end

    def self.arr_flex pquestion
      return ResponseSets::ResponseSetArrFlex.new pquestion
    end

    def self.dual_arr pquestion
      return ResponseSets::ResponseSetDualArr.new pquestion
    end

    def self.arr_mult_drop pquestion
      return ResponseSets::ResponseSetArrMultDrop.new pquestion
    end

    def self.arr_mult_text pquestion
      return ResponseSets::ResponseSetArrMultText.new pquestion
    end
  end

  module ResponseSets

    ##
    # Generic response loader for most questions
    # - We need a unified way to tell what the response_rate is
    # - Or the stats loaders can calculate it individually
    class ResponseSetBase
      def has_sql; false end

      def initialize question, opts={}
        @question = question
        @qid = question.qid
        @qtype = question.qtype
        @title = question.title
        @scale_id = 0
        @format_as = question.num_value_int_only? ? :integer : opts[:format_as]
        opts.each_pair do |key, value|
          send("#{key}=", value)
        end
      end

      def question; @question; end
      def qtype; @qtype; end
      def qid; @qid; end
      def title; @title; end
      def status_questions= val; @status_questions = val; end
      def format_as= val; @format_as = val; end

      # Prevent gon/view from having access to question/role_aggregate
      def as_json(options=nil)
        super({:except => ['question', 'status_questions', 'related_columns', 'related_data', 'lime_answers']}.merge(options || {}))
      end

      def lime_answers
        return @lime_answers if defined? @lime_answers
        @lime_answers = @question.lime_answers
        return @lime_answers
      end

      ##
      # Get question containing status of our response
      def status_questions
        #
        #    If parent question with no sub_questions:
        #        - Single status question where stq.question == self.title
        #    else:
        #        - Each sub_question has one status_questions
        #
        return @status_questions if defined? @status_questions
        @status_questions = @question.lime_survey.status_questions.select{|q| status_question_names.include? q.question }
        return @status_questions
      end

      ##
      # Values to look for when gathering status questions
      def status_question_names
        [@question.title]
      end

      ##
      # Find column_names related to this question
      def related_columns
        return @related_columns if defined? @related_columns
        @related_columns = find_related_columns [@question.my_column_name]
      end

      def status_column_conversions
        @status_column_conversions ||= Hash[related_columns.zip(related_error_columns)]
      end

      ##
      # Find error columns related to this question
      def related_error_columns
        return @related_error_columns if defined? @related_error_columns
        @related_error_columns = []
        if status_questions
          @related_error_columns = find_related_columns status_questions.map{|sq| sq.my_column_name }
        end
        return @related_error_columns
      end

      ##
      # generic finder, find columns starting with
      def find_related_columns col_names
        result = []
        col_names.each do |col_name|
          result += @question.lime_data.column_names.select{|val| val.start_with? col_name }
        end
        return result
      end

      ##
      # Get all data for these column names
      def find_related_data col_names
        # ['col1', 'col2', 'col3'] => {'col1'=>[], 'col2'=>[], 'col3'=>3}
        return {} if col_names.empty?
        result = Hash[col_names.map{|col| [col, []] }]
        # push data from dataset
        @question.lime_survey.lime_data.dataset.each do |row|
          col_names.each do |col|
            result[col].push row[col]
          end
        end
        return result
      end

      ##
      # Find all data related to this question
      def related_data
        return @related_data if defined? @related_data
        # ['col1', 'col2', 'col3'] => {'col1'=>[], 'col2'=>[], 'col3'=>3}
        @related_data = find_related_data(related_columns)
        return @related_data
      end

      ##
      # Find all data related to this question
      def related_error_data
        return @related_error_data if defined? @related_error_data
        # ['col1', 'col2', 'col3'] => {'col1'=>[], 'col2'=>[], 'col3'=>3}
        @related_error_data = find_related_data(related_error_columns)
        return @related_error_data
      end

      ##
      # Count the number of valid responses
      def response_count
        return @response_count if defined? @response_count
        @response_count ||= data_empty? ? 0 : related_data.first[1].count{|val|!val.to_s.empty?}
      end

      def response_total
        @response_total ||= data_empty? ? 0 : related_data.first[1].count
      end

      ##
      # Does this response_set have an empty dataset?
      def data_empty?
        (related_data.empty? || related_data.first.size < 2)
      end

      ##
      # Automatic formatting for values (primarily for errors and integers)
      def do_format(val, err_val=nil)
        if val.to_s.empty?
          return err_val
        end
        # Deal with floats if they should be INTS
        if @format_as == :integer
          return val.to_i
        end
        if @format_as == :float
          return val.to_f
        end
        return val
      end

      def data_column_name
        return @data_column_name if defined? @data_column_name
        @data_column_name = related_data.keys.first
      end
    end

    class ResponseSetGeneric < ResponseSetBase
      ##
      # Generic data collector for a response set
      def data
        return @data if defined? @data
        if data_empty?
          @data = []
          return
        end
        @data = related_data[data_column_name].dup
        ekey = related_error_data.keys.first
        edata = related_error_data[ekey] || []
        @data.each_with_index do |val, idx|
          @data[idx] = do_format(val, edata[idx])
        end
        return @data
      end

      ##
      # Possible labels for nulls in the data
      def error_labels
        return @error_labels if defined? @error_labels
        @error_labels = {}
        return @error_labels if status_questions.empty?
        status_questions.first.parent_question.lime_answers.each{|ans|@error_labels[ans.code] = ans.answer}
        return @error_labels
      end

      ##
      # Labels for values in the data
      def data_labels
        return @data_labels if defined? @data_labels
        @data_labels = {}
        lime_answers.each{|ans|@data_labels[ans.code] = ans.answer if scale_id == ans.scale_id}
        return @data_labels
      end
    end

    class ResponseSetFileUpload < ResponseSetBase
      def data
        return @data if defined? @data
        if data_empty?
          @data = []
          return
        end
        col = question.my_column_name
        @data = []
        question.lime_data.dataset.each do |row|
          if row[col].to_s.empty?
            @data.push({:files=>[]})
            next
          end
          @data.push({:files=>JSON.parse(row[col]), :row_id=>row['id']})
        end

        return @data
      end

    end

    ##
    #
    class ResponseSetNumeric < ResponseSetGeneric

      def initialize question, opts={}
        super(question, opts)
        @format_as ||= :float
      end

      def data_labels
        @data_labels ||= {}
      end
    end


    ##
    #
    class ResponseSetYesNo < ResponseSetGeneric

      def data_labels
        @data_labels ||= {'N'=>'No', 'Y'=>'Yes'}
      end

    end

    ##
    #
    class ResponseSetGender < ResponseSetGeneric

      def data_labels
        @data_labels ||= {'M' => 'Male', 'F'=>'Female'}
      end

    end

    ##
    #
    class ResponseSetGenericParent < ResponseSetGeneric
      ##
      # Get question containing status of our response
      def status_question_names
        @status_question_names ||= question.sub_questions.map{|squestion|"#{question.title}_#{squestion.title}"}
      end

      ##
      # TODO: There was a bug where the wrong status question would get loaded for a sub question
      #       it is very likely that this effects all questions that use a sub_question.
      #       Proposal:
      #       - Move this into ResponseSetGenericParent and test that the data comes out correctly
      #       - Subclasses:
      #           - ResponseSetDualArr
      #           - ResponseSetMultText
      #           - ResponseSetArrFlex
      #           - ResponseSetMultNumeric
      def select_status_questions sq
        status_questions.select{|statq|statq.question == "#{question.title}_#{sq.title}"}
      end


    end

    class ResponseSetMult < ResponseSetGenericParent
      CODE_OTHER ||= '0' # Code used to represent "Other" was checked

      def has_sql; true end

      def data
        return @data if defined? @data
        qlist = []
        question.sub_questions.each do |sq|
          responses = related_data[sq.my_column_name] || []
          qlist.push([sq, responses])
        end
        @data = get_data(qlist)
      end

      def get_data q_data
        # convert responses into their title values
        # [ y n y y n ] [ y y y y y ] [ y n y n y ]  => [ red blu red red blu ]
        # [ y y y y y ] [ n n n n n ] [ y n n n y ]     [ red red red red red ] ...
        result = q_data.                                            # Paired sq response set
          map{|sq, responses|                                     # Each response
          title = sq.nil? ? CODE_OTHER : sq.title             # Get title
          responses.map{|val|val.to_s.empty? ? val : title }  # Convert to title
        }
        # flip nested array into array of values for each checkbox
        # [ y n y y ] [ y n y y ] [ n n n n ] => [ [y,y,n] ] [ [n,n,n] ] [ [y,y,n] ] [ [y,y,n] ]
        # [ y y y y ] [ y y y y ] [ n n n n ]    [ [y,y,n] ] [ [y,y,n] ] [ [y,y,n] ] [ [y,y,n] ] ...
        result = result.transpose
        # Convert nested array to string, remove empty values
        #[ [y,y,n] ] [ [n,n,n] ] [ [y,y,n] ] [ [y,y,n] ] => [ 'y/y' ] [ ''    ] [ 'y/y' ] [ 'y/y' ]
        #[ [y,y,n] ] [ [y,y,n] ] [ [y,y,n] ] [ [y,y,n] ]    [ 'y/y' ] [ 'y/y' ] [ 'y/y' ] [ 'y/y' ]
        result.map!{|vals|vals.delete_if{|val|val.to_s.empty?}.compact}

        return result if related_error_data.empty?

        # Swap out empty arrays with error codes
        result.each_with_index do |vals, idx|
          next unless vals.empty?
          vals.push related_error_data.first[1][idx]
        end
        return result
      end

      def data_labels
        return @data_labels if defined? @data_labels
        @data_labels = {CODE_OTHER=>'Other'}
        question.sub_questions.each do |squestion|
          next if squestion.my_column_name.end_with? 'other'
          @data_labels[squestion.title] = squestion.question
        end
        return @data_labels
      end

    end

    class ResponseSetMultComment < ResponseSetMult
      def comments
        return @comments if defined? @comments
        result = []
        question.sub_questions.each do |sq|
          result.push related_data["#{sq.my_column_name}comment"]
        end
        @comments = result
      end

      def data_labels
        return @data_labels if defined? @data_labels
        @data_labels = {}
        question.sub_questions.each do |squestion|
          next if squestion.my_column_name.end_with? 'other'
          @data_labels[squestion.title] = squestion.question
        end
        return @data_labels
      end
    end

    ##
    #
    class ResponseSetMultNumeric < ResponseSetGenericParent
      def has_sql; true end

      def data_labels
        return {}
      end

      def data
        return @data if defined? @data
        @data = []
        question.sub_questions.each do |sub_question|
          @data.push ResponseSetNumeric.new sub_question,
            :status_questions=>select_status_questions(sub_question),
            :format_as=>@format_as
        end
        return @data
      end
    end

    ##
    #
    class ResponseSetMultText < ResponseSetMult
      def data_labels
        return {}
      end

      def data
        return @data if defined? @data
        @data = []
        question.sub_questions.each do |sub_question|
          @data.push ResponseSetGeneric.new sub_question,
            :status_questions=>select_status_questions(sub_question)
        end
        return @data
      end
    end

    ##
    #
    class ResponseSetArrFlex < ResponseSetGenericParent

      def data
        return @data if defined? @data
        @data = []
        question.sub_questions.each do |sub_question|
          @data.push ResponseSetGeneric.new sub_question,
            :status_questions=>select_status_questions(sub_question),
            :status_question_names=>status_question_names,
            :data_labels=>data_labels
        end
        return @data
      end


    end

    ## This one is NOT working very well.  Need to fix the log a bit.
    #
    class ResponseSetArrMultDrop < ResponseSetGenericParent

      def data_labels
        return {}
      end

      def data
        return @data if defined? @data
        @data = []
        question.sub_questions.each do |sub_question|
          @data.push ResponseSetGeneric.new sub_question,
            :status_questions=>select_status_questions(sub_question)
        end
        return @data
      end
    end

    ## array with multiple text (2-dimensional array)
    #
    class ResponseSetArrMultText < ResponseSetGeneric

      def data_labels
        return {}
      end

      def data
        #return @data if defined? @data
        @data = []
        question.sub_questions.each do |sub_question|
          @data.push ResponseSetGeneric.new sub_question,
            :status_questions=>select_status_questions(sub_question),
            :format_as=>@format_as
        end

        return @data
      end
    end

    ##
    #
    class ResponseSetDualArr < ResponseSetGeneric
      def has_sql; true end

      def data
        return @data if defined? @data
        @data = []
        # For each sub_question
        question.sub_questions.each do |sub_question|
          # Generate a response_set for part_a
          @data.push ResponseSetGeneric.new(sub_question, :scale_id=>0, :status_questions=>status_questions,
                                            :related_error_columns=>get_error_cols(sub_question, 0),
                                            :lime_answers=>lime_answers, :data_column_name=>"#{sub_question.my_column_name}#0",
                                            :title=>question.qattrs['dualscale_headerA'], :qtype=>:dual_arr_child)

          # Generate a response_set for part_b
          @data.push ResponseSetGeneric.new(sub_question, :scale_id=>1, :status_questions=>status_questions,
                                            :related_error_columns=>get_error_cols(sub_question, 1),
                                            :lime_answers=>lime_answers, :data_column_name=>"#{sub_question.my_column_name}#1",
                                            :title=>question.qattrs['dualscale_headerB'], :qtype=>:dual_arr_child)
        end
        return @data
      end

      private
      ##
      # Get the column names for status questions
      #   - Each sub_question has two status_questions
      def status_question_names
        return @status_question_names if defined? @status_question_names
        @status_question_names = question.sub_questions.map{|sq|dual_scale_title(sq, 0)}
        @status_question_names += question.sub_questions.map{|sq|dual_scale_title(sq,1)}
        return @status_question_names
      end

      def status_questions
        @status_questions || question.lime_survey.status_questions
      end

      def get_error_cols sub_question, scale_id
        [status_questions.find{|sq| sq.title == dual_scale_title(sub_question, scale_id) }.my_column_name]
      end

      def dual_scale_title sub_question, scale_id
        "#{question.title}#{sub_question.title}#{scale_id}"
      end

    end
  end
end
