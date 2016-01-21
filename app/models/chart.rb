class Chart < ActiveRecord::Base

    MAX_GROUPS = 2
    MAX_CHART_SERIES = 3

    attr_accessible :title, :chart_type, :aggregator_type,
        :is_public, :width, :height, :dataset,
        :chart_series_attributes, :user_id, :cols, :rows, :years_filter
    attr_accessor :show_controls

    has_one :dash_widget, :class_name=>'DashboardWidget', :as=>:widget
    has_many :chart_series, -> { order :created_at }, :inverse_of=>:chart, :dependent=>:destroy
    belongs_to :user, :inverse_of=>:charts
    accepts_nested_attributes_for :chart_series, :allow_destroy => true
    validates_presence_of :user
    validate :validate_max_number_of_groups
    validate :validate_max_number_of_series

    serialize :cols, Array
    serialize :rows, Array
    serialize :years_filter, Array

    # Strip leading and trailing whitespace from title during save
    before_save {|chart|
        chart.title.strip!
        if chart.title.empty?
            if chart.new_record?
                suffix = user.charts.size + 1
            else
                suffix = user.charts.index{|uchart|uchart.created_at == chart.created_at}.to_i + 1
            end
            chart.title = "Untitled #{suffix}"
        end
    }

    rails_admin do
        navigation_label 'User Content'
        field :user do
            inline_add false
            inline_edit false
        end
        field :title, :string
        field :chart_type
        field :aggregator_type
        field :chart_series
        field :cols
        field :rows
    end

    def any_changed?
        return changed? || chart_series.map{|cs|cs.changed?}.include?(true)
    end

    def validate_max_number_of_groups
        return if questions.empty?

        groups = questions.map{|question|question.meta_attribute_entity_group}.uniq
        if groups.size > MAX_GROUPS
            errors.add :chart_series, 'A maximum of 2 groups are allowed'
        end
    end

    def validate_max_number_of_series
        return if chart_series.nil? || chart_series.empty?
        if chart_series.size > MAX_CHART_SERIES
            errors.add :chart_series, 'A maximum of 3 series are allowed'
        end
    end

    def allow_more_chart_series?
        chart_series.size < MAX_CHART_SERIES
    end

    def allow_more_groups?
        groups.size < MAX_GROUPS
    end

    def chart_type_enum
        return [
            "Table",
            "Table Barchart",
            "Heatmap",
            "Row Heatmap",
            "Col Heatmap",
            "Line Chart",
            "Bar Chart",
            "Stacked Bar Chart",
            "Area Chart"
        ]
    end

    def aggregator_type_enum
        return %w'count countUnique listUnique intSum sum average sumOverSum ub80 lb80 sumAsFractionOfTotal sumAsFractionOfRow sumAsFractionOfCol
            countAsFractionOfTotal countAsFractionOfRow countAsFractionOfCol undefined'
    end

    def chart_type_name
        self[:chart_type].nil? ? nil : self.chart_type_enum.invert[self[:chart_type]]
    end

    # Access the dataset from the datamaker
    def dataset
        @dataset ||= data_maker.dataset
    end

    # Create the datamaker object if it does not yet exist
    def data_maker
        @data_maker ||= ::EdnaConsole::DataMaker.new(self.questions)
    end

    # Any listed question that is not in rows
    def cols_enum
        data_maker.questions.
            map{|q|q.attribute_name}.
            uniq.select{|val| val.size > 0 && !self.rows.include?(val)}
    end

    # Any listed question that is not in cols
    def rows_enum
        data_maker.questions.
            map{|q|q.attribute_name}.
            uniq.select{|val| val.size > 0 && !self.cols.include?(val)}
    end

    def cols= val
        write_attribute :cols, val.reject{|col|col==''}
    end

    def rows= val
        write_attribute :rows, val.reject{|row|row==''}
    end


    # customize serialized output for this model
    # Will automatically show up on to_json, to_xml etc...
    def serializable_hash(options={})
        options = {
          :methods=>[:attr_names, :dataset, :questions, :max_series_count],
          :chart_series=>{
              :methods=>[:attribute_name, :short_name]
          }
        }.update(options)
        super(options)
    end

    def max_series_count
        MAX_CHART_SERIES
    end

    # return all meta_attribute_questions associated with this chart
    def questions
        ready_series = chart_series.select{|series|series.ready_for_data?}
        result = []
        ready_series.each{|series|result += series.meta_attribute_questions}
        return result.uniq.sort_by{|series|series.category}
    end

    def groups
        questions.map{|question|question.meta_attribute_entity_group}.uniq
    end

    def attr_names
        result = {'year'=>'year'}
        chart_series.each do |series|
            result[series.attribute_name] = series.short_name
            result[series.short_name] = series.attribute_name
        end
        return result
    end

    def content
        {}
    end
end
