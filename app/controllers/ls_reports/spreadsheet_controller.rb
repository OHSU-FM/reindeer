class LsReports::SpreadsheetController < LsReports::BaseController
  layout 'full_width'
  helper :all
  include LsReports::SpreadsheetHelper
  include LsReports::CompetencyHelper
  include LsReports::ClinicalphaseHelper
  include EpasHelper
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

    @response_sets = hf_flatten_response_sets @lime_survey
    @rs_data = hf_transpose_response_sets @response_sets

    @rs_data.sort_by!{|obj| obj["StartDt"]}
    @rs_questions = hf_transpose_questions @response_sets

    @response_sets_unfiltered = hf_flatten_response_sets @lime_survey_unfiltered
    @rs_data_unfiltered = hf_transpose_response_sets @response_sets_unfiltered

    @rs_questions_unfiltered = hf_transpose_questions @response_sets_unfiltered
    @comp_domain_desc = hf_comp_domain_desc

    @non_clinical_course_arry = hf_get_non_clinical_courses

    @comp_hash3_nc = hf_load_all_competencies_nc(@rs_data, "3")
    @comp_hash3 = hf_load_all_competencies(@rs_data, "3")

    @comp_hash2 = hf_load_all_competencies(@rs_data, "2")
    @comp_hash1 = hf_load_all_competencies(@rs_data, "1")
    @comp_hash0 = hf_load_all_competencies(@rs_data, "0")

    @comp_level3 = hf_comp_courses(@rs_data, "3")
    @comp_level2 = hf_comp_courses(@rs_data, "2")
    @comp_level1 = hf_comp_courses(@rs_data, "1")
    @comp_level0 = hf_comp_courses(@rs_data, "0")


    if @pk == "_"
      if current_user.permission_group.title.include? "Students"
        @pk = current_user.email
        get_all_blocks_data
      end
    else
      get_all_blocks_data
    end
    #@all_comp_hash3 = hf_load_all_competencies(@rs_data_unfiltered, "3")
    if hf_found_competency(@response_sets)
      @rs_data.sort_by!{|obj| obj["SubmitDt"]}.reverse!
      export_to_gon
      render :show_epa
    else
      @rs_data.sort_by!{|obj| obj["StartDt"]}
      render :show
    end
  end

  def get_all_blocks_data
    surveys = @lime_survey.lime_surveys_languagesettings
    @allblocks = hf_get_all_blocks(surveys, @pk)
    if !@allblocks.empty?
      @allblocks_class_mean = hf_get_all_blocks_class_mean(surveys)
    end

    @cpx_data = hf_get_cpx(surveys)
    @usmle_data = hf_get_usmle(surveys)
    @shelf_attachments = hf_get_shelf_attachments(surveys)
    @preceptorship = hf_get_preceptorship(surveys, @pk)
    @preceptor_view = @preceptorship.flatten
    @artifacts_student = hf_get_artifacts(@pk)
    #@epa_adhoc, @epa_headers = hf_get_epa_adhoc(surveys)
    @epas, @epa_hash, @epa_evaluators, @unique_evaluators, @selected_dates = hf_get_epas(@pk)

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
    gon.rs_data = @rs_data.to_json

    gon.comp_domain = hf_comp_domain
    @comp_data_clinical = hf_average_comp (@comp_hash3)
    @comp_data_non_clinical = hf_average_comp (@comp_hash3_nc)

    #@merged_comp = @comp_data_clinical.merge(@comp_data_non_clinical){|key,oldval,newval| [*oldval].to_a + [*newval].to_a }

    gon.series_data_comp_2 = @comp_data_clinical
    gon.series_data_comp_2_nc = @comp_data_non_clinical

    gon.all_comp_codes = hf_all_comp_codes
    @comp_class_mean = hf_competency_class_mean(@rs_data_unfiltered)
    gon.comp_class_mean = @comp_class_mean


    gon.allblocks = @allblocks
    gon.allblocks_class_mean = @allblocks_class_mean
    gon.epa_adhoc = @epa_hash #@epa_adhoc
    gon.epa_evaluators = @epa_evaluators
    gon.unique_evaluators = @unique_evaluators
    gon.selected_dates = @selected_dates

    #gon.preceptorship = @preceptorship
    #preceptorship data is not sent over to coffeescripts to process.


  end
end
