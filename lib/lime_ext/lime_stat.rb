module LimeExt::LimeStat

  class QuestionStat

    def initialize response_set, opts = {}
      @response_set = response_set
      @question = response_set.question
      @q_text = @question.question
      @role_aggregate = @question.lime_group.lime_survey.role_aggregate
      unless @role_aggregate
        fail(:role_aggregate)
      end
      @sub_stats = []
      @categorical_stats = []
      @descriptive_stats = nil
      @response_count = @response_set.response_count
      @qid = @question.qid
      @qtype = @question.qtype
      @title = @question.title
      opts.each_pair do |key, value|
        send("#{key}=", value)
      end
    end

    def qtype; @qtype; end
    def qtype= val; @qtype = val; end
    def sub_stats; @sub_stats; end
    def descriptive_stats= val; @descriptive_stats = val; end
    def categorical_stats; @categorical_stats; end
    def categorical_stats= val; @categorical_stats = val; end
    def question; @question; end

    # Find category stat
    def find_category_pair cat
      pcat = categorical_stats.find{|cs|cs.code == cat.code}
      if pcat.nil?
        pcat = CategoricalStatistics.new @question, cat.code, cat.item_id, cat.qtype, [], cat.data_labels, cat.error_labels
      end
      pcat
    end

    # Prevent gon/view from having access to question/role_aggregate
    def as_json(options=nil)
      super({:except => ['question', 'role_aggregate', 'response_set']}.merge(options || {}))
    end

    def response_rate
      if @response_set.response_total == 0
        @response_rate = 0
        return
      end
      @response_rate ||= (@response_count.to_f / @response_set.response_total) * 100
    end

    # The number of unique records with responses.  Unique by pk_fieldname.
    def pk_count
      @pk_count ||= count_unique_related @role_aggregate.pk_fieldname
    end

    # The number of unique records with responses.  Unique by agg_fieldname.
    def agg_count
      @agg_count ||= count_unique_related @role_aggregate.agg_fieldname
    end

    private

    # Count the number of unique responses in one field while using a question as a mask
    def count_unique_related fieldname
      return 0 if fieldname.to_s.empty?       # No fieldname assigned
      return 0 unless response_set.data       # No data in our dataset

      # Get data for fieldname
      field_data =  @question.lime_data.responses_for(fieldname)
      # Get index of all values that are not empty
      idx = []
      @response_set.data.each_with_index{|val, i|idx.push(i) if val != ''}
      return 0 if idx.empty?
      # get only values in idx, count uniq
      return field_data.values_at(*idx).uniq.count
    end
  end

  class DescriptiveStatistics

    def initialize data, opts={}
      return if data.empty?

      # Set default values
      @confidence_level = 0.95
      @range = []
      @confidence_interval = []

      # allow options to override defaults
      opts.each_pair do |key, value|
        send("#{key}=", value)
      end

      # run calculations
      stats = ::DescriptiveStatistics::Stats.new data

      # Basic Stats
      @mean = stats.mean
      @median = stats.median
      #@mode =  stats.mode <- Not available
      @sum = stats.sum
      @range = [stats.min, stats.max]
      @n = data.count
      # Confidence Interval of Mean
      # http://stattrek.com/estimation/confidence-interval.aspx
      @standard_deviation = stats.standard_deviation
      return if @standard_deviation.nil?
      @standard_error = @standard_deviation / Math.sqrt(@n)
      @alpha = 1 - (@confidence_level/100)
      @crit_p = 1 - @alpha/2
      @df = @n - 1
      @crit_v = Statistics2.tdist(@df, @crit_p)
      @margin_of_error = @crit_v * @standard_error
      @confidence_interval = [@mean - @margin_of_error, @mean + @margin_of_error]
    end

  end

  class CategoricalStatistics

    def self.generate_titled_stats question, title, qtype, data, data_labels, error_labels
      return {
        title: title,
        categories: self.generate_stats(question, qtype, data, data_labels, error_labels)
      }
    end

    # Return array of categorical_statistics
    def self.generate_stats question, qtype, data, data_labels, error_labels
      results = []
      data ||= []
      # Generate stats for each category
      data_labels.each do |code, val|
        cstat = self.new question, code, results.size, qtype, data, data_labels, error_labels
        results.push cstat
      end

      # Sort data labels
      results = results.sort_by{|cstat| [cstat.code.to_f, cstat.code] }

      # Continue stats generation
      error_labels.each do |code, val|
        cstat = self.new question, code, results.size, qtype, data, data_labels, error_labels
        results.push cstat
      end
      other_keys = data.uniq.to_set - (error_labels.keys + data_labels.keys).to_set
      other_keys.each do |code|
        cstat =  self.new question, code, results.size, qtype, data, data_labels, error_labels
        results.push cstat
      end
      return results
    end

    # Return statistics for a single category
    def initialize question, code, item_id, qtype, data, data_labels, error_labels
      data ||= []
      @question = question
      @data_labels = data_labels
      @error_labels = error_labels
      @role_aggregate = question.lime_group.lime_survey.role_aggregate
      @code = code
      @item_id = item_id
      @qtype = qtype
      @total = data.count
      @is_err = !data_labels.keys.include?(code)
      @answer = data_labels[code] || error_labels[code] || code
      # count occurrences or include? if is array
      is_array = data.first.respond_to?('each')
      @frequency = data.count{|val| is_array ? val.include?(code) : val == code}
      @pk_frequency = count_unique_related(@role_aggregate.pk_fieldname, data)
      @agg_frequency = count_unique_related(@role_aggregate.agg_fieldname, data)
      @percent = (@frequency.to_f / @total) * 100
      @percent = 0 if @total == 0
    end

    def code; @code; end
    def answer; @answer; end
    def frequency; @frequency; end
    def pk_frequency; @pk_frequency; end
    def percent; @percent; end

    # Prevent gon/view from having access to data
    def as_json(options=nil)
      super({ except: ['data', 'question', 'role_aggregate'] }.merge(options || {}))
    end

    ##
    # Return the number of unique values in another field where our field == filter
    def count_unique_related unique_fieldname, data
      # bail if no data
      return 0 if data.empty?

      # Get index of all values that are not equal to filter
      idx = []
      data.each_with_index{|val, i| idx.push(i) if val == @code }

      # Bail if nothing was found
      return 0 unless idx

      # count unique values
      values =  @question.lime_data.responses_for(unique_fieldname).values_at(*idx)
      return values.uniq.count{|val|val != ''}
    end

  end

  class TextStatistics
    def initialize data
    end
  end

  # Return an array of graph objects for use in graphs
  class LimeStat

    def initialize lime_survey
      @lime_survey = lime_survey
    end

    def dataset
      return lime_survey.dataset
    end

    ##
    #   Load duar_arr question and include applicable statistics
    #   responses in "#{pquestion.my_column_name}#{pq.sub_question.code}##{pq.lime_answer.code}
    def load_dual_arr(response_set, opts={})
      # Instantiate QuestionStat
      qstat = QuestionStat.new response_set, opts
      response_set.data.each do |sub_rs|
        sub_stat = load_list_drop(sub_rs, opts)
        sub_stat.qtype = "dual_arr_child"
        qstat.sub_stats.push sub_stat
      end
      return qstat
    end

    ##
    # No stats
    def load_long_text(response_set, opts={})
      # Instantiate QuestionStat
      return QuestionStat.new response_set, opts
    end

    ##
    # t
    def load_huge_text(response_set, opts={})
      # Instantiate QuestionStat
      return QuestionStat.new response_set, opts
    end

    ##
    # t
    def load_short_text(response_set, opts={})
      # Instantiate QuestionStat
      return QuestionStat.new response_set, opts
    end

    ##
    # load_q handles q type question (multiple short text) from Lime_survey
    def load_mult_short_text(response_set, opts={})
      # Instantiate QuestionStat
      return QuestionStat.new response_set, opts
    end

    ##
    #
    def load_mult_numeric(response_set, opts={})
      # Instantiate QuestionStat
      # opts[:response_count] = response_set.related_data.map{|k,v|v}.transpose.map{|row|row.compact}.reject{|r|r.empty?}.count
      # opts[:response_rate] = (opts[:response_count] / response_set.response_count.to_f) * 100
      qstat = QuestionStat.new response_set, opts
      response_set.data.each do |rs|
        qstat.sub_stats.push load_numeric(rs)
      end
      return qstat
    end

    ##
    # The data for mult type questions is stored in the responses of each of the sub_questions
    # we need to pull all of those responses together and convert them to text
    def load_mult response_set, opts={}
      rs  = response_set
      # Instantiate QuestionStat
      qstat = QuestionStat.new(rs, opts)
      if opts[:group_checkbox_responses] == true
        data = []
        error_labels = {}
        data_labels = {}
        rs.data.each do |vals|
          codes = vals.join('/')
          if rs.data_labels.include? vals.first
            data_labels[codes] = vals.map{|code|rs.data_labels[code]}
          else
            error_labels[codes] = vals.map{|code|rs.error_labels[code]}
          end
          data.push codes
        end
      else
        error_labels = rs.error_labels
        data_labels = rs.data_labels
        data = rs.data
      end

      # Run calculation
      qstat.categorical_stats = CategoricalStatistics.generate_stats rs.question,
        rs.qtype, data, data_labels, error_labels
      return qstat
    end

    def load_mult_w_comments response_set, opts={}
      return load_mult response_set, opts
    end

    ##
    #
    def load_list_drop response_set, opts={}
      rs = response_set
      qstat = QuestionStat.new rs
      # Generate Categorical stats
      qstat.categorical_stats = CategoricalStatistics.generate_stats rs.question,
        rs.qtype, rs.data, rs.data_labels, rs.error_labels
      return qstat
    end

    ##
    #
    def load_arr_flex response_set, opts={}
      rs = response_set
      qstat = QuestionStat.new rs
      rs.data.each do |sub_rs|
        sub_stat = QuestionStat.new sub_rs
        sub_stat.qtype = "#{qstat.qtype}_child"
        # Generate Categorical stats
        # Note: Inconsistent qtype for sub_questions, force qtype to be arr_flex
        sub_stat.categorical_stats = CategoricalStatistics.generate_stats sub_rs.question,
          sub_stat.qtype, sub_rs.data, sub_rs.data_labels, sub_rs.error_labels
        qstat.sub_stats.push sub_stat
      end
      return qstat
    end

    ##
    # Stats for yes_no type questions
    def load_yes_no response_set, opts={}
      load_list_drop response_set, opts
    end

    def load_list_radio response_set,  opts={}
      load_list_drop response_set, opts
    end

    ##
    # Stats for yes_no type questions
    def load_gender response_set, opts={}
      rs = response_set
      qstat = QuestionStat.new rs
      # Generate Categorical stats
      qstat.categorical_stats = CategoricalStatistics.generate_stats rs.question,
        rs.qtype, rs.data, rs.data_labels, rs.error_labels
      return qstat
    end

    ##
    # load_n handles N type question - single numerical input
    def load_numeric(response_set, opts={})
      qstat = QuestionStat.new response_set, opts
      error_labels = response_set.error_labels
      data = response_set.data.map{|val|error_labels.include?(val) ? nil : val}.compact
      #begin
      qstat.descriptive_stats = DescriptiveStatistics.new(data)
      #rescue RuntimeError => e
      #    puts 'ERROR'
      #    Rails.logger.warn e
      #    qstat.descriptive_stats = nil
      #end
      return qstat
    end

    ##
    # Load data for all questions
    def load_data(opts={})
      temp_questions = []
      @lime_survey.lime_groups.each do |lgroup|
        lgroup.parent_questions.each do |pquestion|
          # Only return the stats for questions that are not hidden
          temp_questions.push generate_stats_for_question(pquestion, opts) unless pquestion.hidden?
        end
      end
      return temp_questions
    end

    ##
    #
    def generate_stats_for_question pquestion, opts={}
      method_name = "load_#{pquestion.qtype}"
      if self.respond_to? method_name
        return self.send(method_name, pquestion.response_set, opts)
      else
        return QuestionStat.new pquestion.response_set, opts
      end
    end

  end
end
