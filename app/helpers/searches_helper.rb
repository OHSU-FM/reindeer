module SearchesHelper

  def probe_dataset(lime_survey)
    student_data = []
    student_email_col = lime_survey.student_email_column
    comp_data = lime_survey.lime_groups.first.lime_questions.first.dataset
    student_data = comp_data.select {|rec| rec["#{student_email_col}"] == @pk}
    return student_data

  end


  def hf_datasets (result)
    survey_array = []
    if result.coaching_type == 'student'
      
      surveygrps = result.permission_group.permission_ls_groups
      surveygrps = surveygrps.sort_by(&:updated_at)
      surveygrps.each do |s|
        survey = s.lime_survey.title
        sid = s.lime_survey.sid
        if current_user.superadmin? and !probe_dataset(s.lime_survey).empty?
          survey_array.push sid.to_s + "~" + survey
        elsif survey.include? "Graph View" or survey.include? "Remediation" or survey.include? "Core Clinical/Electives"
           if !probe_dataset(s.lime_survey).empty?
              survey_array.push sid.to_s + "~" + survey
           end
        end
      end
      return survey_array
     else
      return ["Not Applicable"]
     end
  end

  def hf_graph_type (dataset)
    if dataset.include? "Core Clinical" or dataset.include? "Remediation"
      return "spreadsheet"
    else
      return "graph"
    end
  end
end
