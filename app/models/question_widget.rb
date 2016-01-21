class QuestionWidget < ActiveRecord::Base

    # Because we use FilterManager
    include LsReportsHelper
    # Because Science
    has_paper_trail

    attr_accessible :role_aggregate_id,
        :user_id,
        :agg,
        :pk,
        :lime_question_qid,
        :dash_widget_attributes,
        :graph_type,
        :view_type

    # Associations
    belongs_to :role_aggregate
    belongs_to :lime_question, :foreign_key=>:lime_question_qid, :primary_key=>:qid
    belongs_to :user
    has_one :dash_widget, :class_name=>'DashboardWidget', :as=>:widget
    has_one :dashboard, :through=>:user

    # ?
    attr_accessor :status

    # Accepted variables
    accepts_nested_attributes_for :dash_widget, :allow_destroy => true
    accepts_nested_attributes_for :dashboard

    # Validations
    validates_presence_of :user
    validates_presence_of :role_aggregate
    validates_inclusion_of :lime_question_qid,
        :in => lambda { |obj| obj.lime_question_enum.map{|arr|arr[1]} },
        :if => lambda { |obj| obj.lime_question_qid_changed? }
    validates_inclusion_of :agg,
        :in => lambda { |obj| obj.agg_enum.map{|arr|arr[1]} },
        :if => lambda { |obj| obj.agg.to_s.empty? ? false : obj.agg_changed? }
    validates_inclusion_of :pk,
        :in => lambda { |obj| obj.pk_enum.map{|arr|arr[1]} },
        :if => lambda { |obj| obj.pk.to_s.empty? ? false : obj.pk_changed? }

    # Sweep up dashboard widget after delete
    after_destroy :delete_dashboard_widget

    # Admin Panel
    rails_admin do
        navigation_label 'User Content'

        field :user do
            inline_edit false
            inline_add false
        end

        field :role_aggregate do
            inline_edit false
            inline_add false
        end
        field :lime_question
        field :pk
        field :agg
        field :dashboard do
            read_only true
        end
        field :dash_widget do
            read_only true
        end
    end

    ###
    # Rails Admin Enumerators
    ###

    def agg_enum
        return [] unless role_aggregate
        role_aggregate.agg_enum
    end

    def pk_enum
        return [] unless role_aggregate
        role_aggregate.pk_enum
    end

    def lime_question_enum
        return [] unless role_aggregate
        role_aggregate.lime_survey.lime_questions.map{|q|[q.title, q.qid] unless q.hidden?}.compact
    end

    ##
    # Output for json
    def content
        begin
            result = {
                :stats=>stats,
                :stats_u=>stats_u,
                :series_name=>fm.series_name,
                :unfiltered_series_name=>fm.unfiltered_series_name,
                :filters_equal=>fm.filters_equal,
                :widget_title=>"#{fm.lime_survey.title}: #{stats.question.lime_group.group_name}(#{stats.question.title})"
            }
        rescue LsReportsHelper::AccessDenied => e
            result = {}
        rescue Dashboard::WidgetExpired => e
            result = {}
        end
        return result
    end

    def fm
        if role_aggregate.nil?
            raise Dashboard::WidgetExpired.new('RoleAggregate missing')
        end

        @fm ||= FilterManager.new user, role_aggregate.lime_survey_sid, :params=>{:agg=>agg, :pk=>pk}
    end

    def stats
        @stats ||= fm.lime_survey.find_question(:qid, lime_question_qid).stats
    end

    def stats_u
        @stats_u ||= fm.lime_survey_unfiltered.find_question(:qid, lime_question_qid).stats
    end

    def delete_dashboard_widget
        return unless dash_widget
        dash_widget.destroy
    end

end
