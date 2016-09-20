class ChartSeries < ActiveRecord::Base

    attr_accessible :group_filter,
        :entities_filter,
        :category_filter,
        :question_filter,
        :question_options_filter,
        :meta_attribute_entities

    serialize :question_options_filter, Array

    belongs_to :chart, :inverse_of=>:chart_series

    rails_admin do
        navigation_label 'User Content'
        field :group_filter
        field :category_filter
        field :question_filter
        field :entities_filter
        field :question_options_filter
    end

    def meta_attribute_questions
        return [] unless ready_for_data?
        return MetaAttribute::MetaAttributeQuestion.
            joins(:meta_attribute_entity).
            where(['meta_attribute_entities.meta_attribute_entity_group_group_name = ?', group_filter]).
            where(['meta_attribute_entities.entity_type IN (?)', entities_filter]).
            where(['meta_attribute_questions.attribute_name = ?', question_filter]).
            where('meta_attribute_questions.visible=true').
            where('meta_attribute_entities.visible=true') || []
    end

    # is this series ready for a datapull?
    def ready_for_data?
        if question_filter.to_s != '' && question_filter_enum.size > 0
            return true
        end
        return false
    end

    # clear other values if we are changed
    def group_filter= val
        self[:group_filter] = val
        if self.group_filter_changed?
            self.category_filter = nil
            self.entities_filter = nil
        end
    end

    # clear other values if we are changed
    def question_filter= val
        self[:question_filter] = val
        if self.question_filter_changed?
            self.entities_filter = nil
        end
    end

    # clear other values if we are changed
    def category_filter= val
        self[:category_filter] = val
        if self.category_filter_changed?
            self.question_filter = nil
            self.entities_filter = nil
        end
    end

    def entities_filter
        # if empty show all
        val = Array(self[:entities_filter]).reject{|j|j==''}
        if val.empty?
            val = entities_filter_enum
        end
        return val
    end

    # group filter enumerator
    def group_filter_enum
        options = MetaAttribute::MetaAttributeEntityGroup.
            where(:visible=>true).
            pluck(:group_name)
        return options if not chart

        # TODO: Remove ugly hack
        bad_val = 'P4 Continuity Clinic Surveys'
        all_groups =  chart.chart_series.map{|series|series.group_filter}
        if all_groups.include? bad_val
            options.delete('P4 Graduate Surveys')
            options.delete('P4 Resident Surveys')
        end
        bad_val = 'P4 Resident Surveys'
        all_groups =  chart.chart_series.map{|series|series.group_filter}
        if all_groups.include? bad_val
            options.delete('P4 Continuity Clinic Surveys')
        end
        return options || []
    end

    def entities_filter_enum
        return [] if group_filter.to_s == '' || question_filter.to_s == ''
        return MetaAttribute::MetaAttributeEntity.
            joins(:meta_attribute_questions).
            where('meta_attribute_entities.visible = true').
            where('meta_attribute_questions.visible = true').
            where(['meta_attribute_entities.meta_attribute_entity_group_group_name = ?', group_filter]).
            where(['meta_attribute_questions.category=?', category_filter]).
            distinct(:entity_type).
            order(:entity_type).
            pluck(:entity_type).sort
    end

    def category_filter_enum
        return [] if group_filter.to_s == ''
        return MetaAttribute::MetaAttributeQuestion.
            joins(:meta_attribute_entity).
            where('meta_attribute_questions.category IS NOT NULL').
            where('meta_attribute_questions.visible = true').
            where('meta_attribute_entities.visible = true').
            where(['meta_attribute_entities.meta_attribute_entity_group_group_name = ?', group_filter]).
            distinct(:category).
            pluck(:category).sort
    end

    def question_filter_enum
        return [] if group_filter.nil? || category_filter.nil?
        q_enum = MetaAttribute::MetaAttributeQuestion.
            joins(:meta_attribute_entity).
            where('meta_attribute_entities.visible = true').
            where('meta_attribute_questions.visible = true').
            where('meta_attribute_questions.category IS NOT NULL').
            where(['meta_attribute_entities.meta_attribute_entity_group_group_name = ?', group_filter]).
            where(['meta_attribute_questions.category=?', category_filter]).
            distinct('attribute_name, short_name').order(:description).pluck(:description,:attribute_name)
        return q_enum.uniq{|desc, attr| attr} || []
    end

    def attribute_name
        return '' if meta_attribute_questions.empty?
        meta_attribute_questions.first.attribute_name
    end

    def short_name
        return '' if meta_attribute_questions.empty?
        meta_attribute_questions.first.short_name
    end

    def description
        return '' if meta_attribute_questions.empty?
        meta_attribute_questions.first.description
    end

    def attribute_names
        return [] if not chart
        result = []
        chart.chart_series.each do |series|
            series.meta_attribute_questions.each do |question|
                result.push question.attribute_name
            end
        end
    end

end

