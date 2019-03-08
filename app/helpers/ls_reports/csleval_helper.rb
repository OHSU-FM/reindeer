module LsReports::CslevalHelper
  include LsReportsHelper

  def get_student_csl(in_data, question, sub_question)
    #locate the hash pair and return the value
    if !sub_question.nil?
       return in_data.map {|d| d["#{question.sid}X#{question.gid}X#{question.qid}#{sub_question.title}"]}
    else
       return in_data.map {|d| d["#{question.sid}X#{question.gid}X#{question.qid}"]}
    end
  end


  def hf_get_csl_evals(in_survey, pk)
    temp_data = in_survey.first.surveyls_title.split(":")
    @student_year = temp_data.second
    csl_surveys = LimeSurveysLanguagesetting.select(:surveyls_survey_id, :surveyls_title).where("surveyls_title like ?", "SA:#{@student_year}:Foundation of Medicine:CSL Narrative%")
    big_array = []
    csl_surveys.each do |survey|
      rr_surveys = RoleAggregate.find_by(lime_survey_sid: survey.surveyls_survey_id)

      limegroups = survey.lime_survey.lime_groups
      #lq = limegroups.first.lime_questions
      student_email_col = survey.lime_survey.student_email_column
      #col_name = get_col_name(lq, "StudentEmail")
      csl_data = survey.lime_survey.dataset  #lq.first.dataset
      student_data = csl_data.select {|rec| rec["#{student_email_col}"] == @pk}
      student_data = student_data.sort_by {|d| d["id"]}

      small_array = []
      temp_hash = {}
      temp_hash = {"csl_survey" => "#{survey.surveyls_title}"}
      small_array.push temp_hash

       limegroups.each do |grp|
          grp.parent_questions.each do |pquestion|
           if ["SelectedStudent","CSLInstructor"].include? pquestion.title
              temp_data = get_student_csl(student_data, pquestion, nil)
              temp_hash = {pquestion.title => temp_data}
              small_array.push temp_hash

           elsif pquestion.title.include? "SpecificComp"
              pquestion.sub_questions.each do |sub_q|
                temp_data = get_student_csl(student_data, pquestion, sub_q)
                temp_hash = {sub_q.question => temp_data}
                small_array.push temp_hash
              end
            elsif  pquestion.title.include? "Comments"
              temp_data = get_student_csl(student_data, pquestion, nil)
              temp_hash = {pquestion.title => temp_data}
              small_array.push temp_hash
            end
          end


      end

      big_array.push small_array
    end
    return big_array  #contains all csl datasets
  end

end
