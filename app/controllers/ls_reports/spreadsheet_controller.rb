class LsReports::SpreadsheetController < LsReports::BaseController
    layout 'full_width'
    include LsReports::SpreadsheetHelper
    include LsReports::CompetencyHelper
    ##
    # show lime_survey
    def show
        load_data
        cols = show_params[:cols].is_a?(Array) ? show_params[:cols] : []
        cols.map{|v|v.to_i}
        if @fm.not_found?
            # Throw redirect on not found
            flash[:error] = 'Nothing left to show after filtering'
            redirect_to ls_reports_path
        end

        @lime_survey.wipe_response_sets

        #@response_sets = hf_get_response_sets @lime_survey, cols
        @response_sets = hf_flatten_response_sets @lime_survey
 
        @rs_data = hf_transpose_response_sets @response_sets
        @rs_data.sort_by!{|obj| obj["StartDt"]}
        @rs_questions = hf_transpose_questions @response_sets

        @response_sets_unfiltered = hf_flatten_response_sets @lime_survey_unfiltered
        @rs_data_unfiltered = hf_transpose_response_sets @response_sets_unfiltered
        @rs_questions_unfiltered = hf_transpose_questions @response_sets_unfiltered


        if hf_found_competency(@response_sets)
            export_to_gon
            render :show_epa
        else
            render :show
        end
    end


    def will_view_raw_data?
        true
    end

    private

    def show_params
        params.permit(:cols=>[])
    end

    def export_to_gon
      @percent_complete = hf_epa_class_mean(@rs_data)
      gon.series_data = @percent_complete

      @class_mean = hf_epa_class_mean(@rs_data_unfiltered)
      gon.series_data_unfiltered = @class_mean 

      gon.series_name = @rs_data.first["StudentName"]   

    end 

end
