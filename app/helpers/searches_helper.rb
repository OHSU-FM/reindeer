module SearchesHelper
  def hf_datasets (result)
    survey_array = []
    if result.coaching_type == 'student'
      surveygrps = result.permission_group.permission_ls_groups
      surveygrps.each do |s|
        survey = s.lime_survey.title
        sid = s.lime_survey.sid
        if survey.include? "Foundation" or survey.include? "Core Clinical/Electives"
           survey_array.push sid.to_s + ":" + survey.split(":").last
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
