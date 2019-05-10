module LsReports::CslevalHelper
  include LsReportsHelper

  DECODE_CSL_EVAL = { '1' => '<font color="red">Rarely demonstrates this behavior</font>',
                      '2' => '<font color="#f46242">Occasionally demonstrates this behavior</font>',
                      '3' => '<font color="#55e529">Often demonstrates this behavior</font>',
                      '4' => '<font color="green">Consistently demonstrates this behavior</font>',
                      '5' => '<font color="blue">Unable to answer</font>',
                      '888' => '<font color="blue">Missing</font>',
                      '' => "Missing"}

  def decode_csl_eval (incode)
    return DECODE_CSL_EVAL[incode]
  end

  def get_student_csl(in_data, question, sub_question)
    #locate the hash pair and return the value
    if !sub_question.nil?
       return in_data.map {|d| d["#{question.sid}X#{question.gid}X#{question.qid}#{sub_question.title}"]}
    else
       return in_data.map {|d| d["#{question.sid}X#{question.gid}X#{question.qid}"]}
    end
  end

  def reshuffle_data(hash_array)
    new_array = []
    temp_hash = {}
    temp_hash = hash_array.select {|k,v| k.to_s.include? "csl_survey"}
    new_array.push temp_hash.first
    temp_hash = hash_array.select {|k,v| k.include? "CSLInstructor"}
    new_array.push temp_hash.first
    temp_hash = hash_array.select {|k,v| k.include? "SelectedStudent"}
    new_array.push temp_hash.first
    temp_hash = hash_array.select {|k,v| k.include? "Narrative Feedback"}
    new_array.push temp_hash.first

    hash_array.each do |data|
      data.each do |key, val|
        if !["csl_survey","CSLInstructor","SelectedStudent", "Narrative Feedback"].include? key
          temp_hash = {key => val}
          new_array.push temp_hash
        end
      end
    end
    return new_array
  end

  def populate_session_var(in_surveys)
    surveys_array  = []
    in_surveys.each do |survey|
      temp_str = survey.surveyls_survey_id.to_s + "~" + survey.surveyls_title
      surveys_array .push temp_str
    end
    session[:search] = nil
    session[:search] = surveys_array

  end


  def hf_get_csl_evals(in_survey, pk)
    temp_data = in_survey.first.surveyls_title.split(":")
    @student_year = temp_data.second
    # this session var contains sid & survey title and it is assgined in Search helper function

    if session[:search].nil?
      csl_surveys = LimeSurveysLanguagesetting.select(:surveyls_survey_id, :surveyls_title).where("surveyls_title like ?", "SA:#{@student_year}:Foundation of Medicine:CSL Narrative%")
      populate_session_var(csl_surveys)
    end

    big_array = []
    #csl_surveys.each do |survey|
    session[:search].each do |data|
      sid = data.split("~").first
      survey_title = data.split("~").second

      rr_survey = RoleAggregate.find_by(lime_survey_sid: sid)
      #survey = LimeSurveysLanguagesetting.select(:surveyls_survey_id, :surveyls_title).where(surveyls_survey_id: sid)
      limegroups = rr_survey.lime_survey.lime_groups
      #lq = limegroups.first.lime_questions
      student_email_col = rr_survey.lime_survey.student_email_column
      #col_name = get_col_name(lq, "StudentEmail")
      csl_data = rr_survey.dataset   #lime_survey.dataset  #lq.first.dataset

      student_data = csl_data.select {|rec| rec["#{student_email_col}"] == @pk}
      student_data = student_data.sort_by {|d| d["id"]}

      small_array = []
      temp_hash = {}
      survey_title = survey_title.split(":").last

      temp_hash = {"csl_survey" => ["#{survey_title}"]}
      small_array.push temp_hash

       limegroups.each do |grp|
          grp.parent_questions.each do |pquestion|
           if ["SelectedStudent","CSLInstructor"].include? pquestion.title
              temp_data = get_student_csl(student_data, pquestion, nil)
              temp_hash = {pquestion.title => temp_data}
              small_array.push temp_hash

           elsif pquestion.title.include? "SpecificComp"
              pquestion.sub_questions.each do |sub_q|
                eval_codes = get_student_csl(student_data, pquestion, sub_q)
                code_array = []
                eval_codes.each do |ecode|
                  code_array.push decode_csl_eval(ecode)
                end
                temp_hash = {sub_q.question => code_array}
                small_array.push temp_hash

              end
            elsif  pquestion.title.include? "Comments"
              temp_data = get_student_csl(student_data, pquestion, nil)
              temp_hash = {"Narrative Feedback" => temp_data}
              small_array.push temp_hash
            end
          end


      end

      fixed_hash = reshuffle_data(small_array)
      big_array.push fixed_hash
    end
    return big_array  #contains all csl datasets
  end

end
