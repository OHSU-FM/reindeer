class LsReports::BaseController < ApplicationController
    include LsReportsHelper
    layout 'full_width_margins'

    ##
    # show lime_survey
    def show
        load_data
        if @fm.not_found?
            # Throw redirect on not found
            flash[:error] = 'Nothing left to show after filtering'
            redirect_to ls_reports_path
        end

        export_to_gon
        render :show
    end

    def show_part
        @view_type = params[:view_type].to_s
        unless RoleAggregate::DEFAULT_VIEWS.include?(@view_type)
            raise ActionController::RoutingError.new('Unknown view type')
        end
        load_data
        @gid = params[:gid]
        @group = @virtual_groups.find{|group|group.gid.to_s==@gid.to_s}
        @qcounter = 0
        @virtual_groups.each do |lg|
            break if lg.gid == @gid
            @qcounter +=  lg.parent_questions.count
        end
        @question_stats = Rails.cache.fetch(cache_key_for_group(@group), :expires_in=>24.hours) do
            @group.parent_questions.map{|pq|pq.stats}
        end

        respond_to do |format|
            format.html { render template: 'ls_reports/shared/show_part.html'}
            format.json { render 'ls_reports/shared/show_part.json' }
        end
    end

    private

    def load_data
        # TODO: Fix this
        # dirty hack to accept forms from graph/filter forms
        kparams = params[:role_aggregate]||{:agg=>params[:agg], :pk=>params[:pk]}
        @sid = params[:sid].to_i
        fm = FilterManager.new current_user, @sid, :params=>kparams
        @fm = fm
        @user = fm.user
        # Alias used in view
        @lime_survey = fm.lime_survey
        @lime_survey_unfiltered = fm.lime_survey_unfiltered
        @pk_enum = fm.pk_enum
        @agg_enum = fm.agg_enum
        @agg = fm.agg
        @pk = fm.pk
        @role_aggregate = @lime_survey.role_aggregate
        @hide_agg = fm.hide_agg
        @hide_pk = fm.hide_pk
        @virtual_groups = fm.virtual_groups
        @filtered_label = @role_aggregate.get_pk_label
        @unfiltered_label = @role_aggregate.get_pk_label.pluralize
        @filtered_label.pluralize if @fm.filters_equal
        # authorize with cancancan
        authorize! :read, @lime_survey
        authorize! :read_raw_data, @lime_survey if will_view_raw_data?
        @view_type = params[:view_type]

        #binding.pry
    end

    def export_to_gon
        gon.filters_equal = @fm.filters_equal

        # Data exports for javascript
        gon.qstats = @lime_survey.lime_stats.load_data
        gon.full_qstats = @lime_survey_unfiltered.lime_stats.load_data

        #
        gon.series_name = @fm.series_name
        gon.unfiltered_series_name = @fm.unfiltered_series_name
    end

    def will_view_raw_data?
        false
    end

end
