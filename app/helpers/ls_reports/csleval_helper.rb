module LsReports::CslevalHelper
  include LsReportsHelper

  DECODE_CSL_EVAL = { '1' => '<font color="red">Rarely demonstrates this behavior</font>',
                      '2' => '<font color="#f46242">Occasionally demonstrates this behavior</font>',
                      '3' => '<font color="#55e529">Often demonstrates this behavior</font>',
                      '4' => '<font color="green">Consistently demonstrates this behavior</font>',
                      '5' => '<font color="blue">Unable to answer</font>',
                      '888' => '<font color="blue">Missing</font>',
                      '' => "Missing"}

 DECODE_CSL_DEF = {
                     'c1' => 'Attends regularly and is well prepared for sessions',
                     'c2' => 'Explains reasoning processes clearly and effectively with regard to solving problems, basic mechanisms, concepts, etc.',
                     'c3' => 'Demonstrates respect, compassion and empathy.',
                     'c4' => 'Seeks to understand others views.',
                     'c5' => 'Takes initiative and provides leadership.',
                     'c6' => 'Shares information/resources',
                     'c7' => 'Seeks appropriate responsibility. Identifies tasks and completes them efficiently and thoroughly.',
                     'c8' => 'Seeks feedback from peers and instructors and puts it to good use.',
                     'c9' => 'Small group behavior is appropriate.'

 }

 def decode_csl_def (incode)
   return DECODE_CSL_DEF[incode]
 end

 def create_csl_hash(csl_evals, in_csl)
   temp_array = []
   csl_data = {}
   my_hash = Hash.new {|h,k| h[k] = [] }
   evals = csl_evals.select{|c| c.csl_title == in_csl}

   evals.each do |e|
      csl_data = {in_csl => e.attributes}
      my_hash[in_csl].push e.attributes
      temp_array.push csl_data
   end

   return my_hash

 end

 def hf_new_csl_evals(pk)
   csl_evals = User.find_by(email: pk).csl_evals.select(:selected_student,:submit_date, :instructor, :feedback,
                :c1, :c2, :c3, :c4, :c5, :c6, :c7, :c8, :c9, :csl_title).order(:submit_date)
   csl_titles = csl_evals.map{|c| c.csl_title}.uniq
   csl_array = []
   csl_titles.each do |title|
     csl_array.push create_csl_hash(csl_evals, title)
   end
   return csl_array
 end


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
      rr_survey = LimeSurvey.where(sid: sid).includes(:lime_groups)
      #survey = LimeSurveysLanguagesetting.select(:surveyls_survey_id, :surveyls_title).where(surveyls_survey_id: sid)
      limegroups = rr_survey.first.lime_groups.includes(:lime_questions)
      #lq = limegroups.first.lime_questions
      student_email_col = rr_survey.first.student_email_column
      #col_name = get_col_name(lq, "StudentEmail")
      csl_data = rr_survey.first.dataset   #lime_survey.dataset  #lq.first.dataset

      student_data = csl_data.select {|rec| rec["#{student_email_col}"] == @pk}
      student_data = student_data.sort_by {|d| d["id"]}

      small_array = []
      temp_hash = {}
      survey_title = survey_title.split(":").last

      temp_hash = {"csl_survey" => ["#{survey_title}"]}
      small_array.push temp_hash

       limegroups.each do |grp|
          pquestions = grp.parent_questions
          pquestions.each do |pquestion|
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
