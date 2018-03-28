module LsReports::ClinicalphaseHelper
  include LsReportsHelper

  BLOCKS = {  'FUND' => "Fundamentals",
              'BLHD' => "Blood & Host Defence",
              'SBM'  => "Skin, Bones & Musculature",
              "CARE" => "Cardiopulmonary & Renal",
              "CPR"  => "Cardiopulmonary & Renal",
              "HODI" => "Hormones & Digestion",
              "NSF"  => "Nervous System & Function",
              "DEVH" => "Developing Human"

  }
  GRAPH_COLOR = ["#8100ba", "#ff79c2", "#b52e2b", "#6cffb1", "#ff0066", "#fff631", "#6f9090"]

  def hf_desc(in_code)
    return BLOCKS[in_code ]
  end

  def get_col_name(grp_questions, title)
     qq = grp_questions.select {|q| q.title = title}
     #{}"851468X295X3975StudentEmail"
     return "#{qq[0].sid}X#{qq[0].gid}X#{qq[0].qid}#{title}"
  end 

  def hf_format_data in_data
    comp = {"FUND"=> [], "BLHD" => [], "SBM" => [], "CARE" => [], "CPR" => [], "HODI" => [], "NSF" => [], "DEVH" => []}
    in_data.each do |data|
      data.each do |k, v|
        if v.nil?
          v = 0
        else
          v = v.to_i
        end

        if k.include? "FUND"
            comp["FUND"].push v
        elsif k.include? "BLHD"
            comp["BLHD"].push v
        elsif k.include? "SBM"
            comp["SBM"].push v
        elsif k.include? "CARE"
            comp["CARE"].push v
        elsif k.include? "CPR"
            comp["CPR"].push v
        elsif k.include? "HODI"
            comp["HODI"].push v
        elsif k.include? "NSF"
            comp["NSF"].push v
        elsif k.include? "DEVH"
            comp["DEVH"].push v
        
        end 
      end
    end
    comp.reject! { |k, v| v.empty?}

    return comp
  end 

  def get_dataset(in_survey, category, dataset)
    temp_data = in_survey.first.surveyls_title.split(":")
    student_year = temp_data.second
    #category = "Foundations of Medicine"
    #dataset = "All Blocks (Graph View)"

    #rr = RoleAggregate.find_by(lime_survey_sid: 851468)
    return LimeSurveysLanguagesetting.find_by(surveyls_title: "SA:#{student_year}:#{category}:#{dataset}")
  end

  def hf_get_all_blocks(in_survey, pk)

    #rr = get_dataset(in_survey, "Foundations of Medicine", "All Blocks (Graph View)")
    #allblocks = {}
    #rr.lime_survey.lime_groups.each do |grp|
    #    lq = grp.lime_questions
    #    col_name = get_col_name(lq, "StudentEmail")
    #    allblocks = lq.first.dataset
    #    student_blocks = allblocks.select {|rec| rec["#{col_name}"] == @pk}
    #    binding.pry
    #    return hf_format_data(student_blocks)
    #end

    comp = {}

    rr = get_dataset(in_survey, "Foundations of Medicine", "All Blocks (Graph View)")
    role = RoleAggregate.find_by(lime_survey_sid: rr.surveyls_survey_id)
    kparams = params[:role_aggregate]||{:agg=>params[:agg], :pk=>params[:pk]}

    new_user = User.find_by(email: pk)
    fm2 = FilterManager.new new_user, role.lime_survey.sid, :params=>kparams
    # Alias used in view
    @lime_survey2 = fm2.lime_survey

    qstats = @lime_survey2.lime_stats.load_data
    qstats.each do |s|
        tmp_data = []
        if !s.title.include? "PersonalData"
          temp_data = s.response_set.data.map {|d| d.data}.flatten
          comp["#{s.title}"] = temp_data

        end

    end
    return comp

  end

  def hf_get_all_blocks_class_mean(in_survey)
    rr = get_dataset(in_survey, "Foundations of Medicine", "All Blocks (Graph View)")
    role = RoleAggregate.find_by(lime_survey_sid: rr.surveyls_survey_id)
    fm_data = role.lime_survey.lime_groups.first.lime_questions.first.lime_stats.load_data

    #qstats = @lime_survey.lime_stats.load_data
    #full_qstats = @lime_survey_unfiltered.lime_stats.load_data

    class_mean = {}
    fm_data.each do |r_data|
      comp = []
      if !r_data.sub_stats.empty?
          #puts r_data.question.title 
          sb =  r_data.sub_stats
          sb.each do |s|
              #puts s.question.title + " ==> " + s.descriptive_stats.mean.to_s
              comp.push s.descriptive_stats.mean.to_s.to_d.truncate(2).to_f
          end
          class_mean["#{r_data.question.title}"] = comp
      end
    end
    @category_labels = fm_data[1].sub_stats.map{|d| d.q_text}

    fm_data = nil
    role = nil
    return class_mean
  end

  def get_data data
    temp_hash = {}
    submit_date = data.select {|k,v| k.include? "SubmitDate"}.first.second  # return the actual date
    responses = data.select {|k,v| k.include? "SBP"}
    temp_data = responses.map {|k,v| v}
    temp_hash = {submit_date => temp_data}
    return temp_hash

  end 

  def format_precept_data in_data
    r_array = []
    in_data.each do |data|
      r_array.push get_data(data)
    end
    #binding.pry
    return r_array
  end 

  def hf_get_preceptorship in_survey
    rr = get_dataset(in_survey, "Preceptorship", "Preceptorship")
    role = RoleAggregate.find_by(lime_survey_sid: rr.surveyls_survey_id)
    fm_data = role.lime_survey.lime_groups.first.lime_questions.first.lime_stats.load_data
    class_precept = {}
    personal_data = rr.lime_survey.lime_groups.select {|g| g.group_name = "Personal Data"}
    lq = personal_data.first.lime_questions
    col_name = get_col_name(lq, "StudentEmail")
    class_precept = lq.first.dataset
    student_precept= class_precept.select {|rec| rec["#{col_name}"] == @pk}
    return format_precept_data(student_precept)

  end

  def hf_reformat_array in_data
    binding.pry
    r_array = []
    i = 0
    in_data.each do |key, val|
      my_hash = {}
      my_hash = {:key => i, :name => key, :data => val, :color => GRAPH_COLOR[i]}
      #r_array.push JSON.generate(my_hash)
      i = i + 1
      r_array.push my_hash
    end
    return r_array
  end

  def get_key key
    case key
      when 0 then return "FUND-Mean"
      when 1 then return "BLHD-Mean"
      when 2 then return "SBM-Mean"
      when 3 then return "CPR-Mean"
      when 4 then return "HODI-Mean"
      when 5 then return "NSF-Mean"
      when 6 then return "DEVH-Mean"
    end
  end

  def hf_reformat_array2 in_data
    binding.pry
    r_array = []
    temp_array = []

    for j in 0..6
      for i in 1..5
        mean_val = in_data["Comp#{i}"][j]
        if !mean_val.nil?
            mean_val = mean_val.to_d.truncate(2).to_f
        else
            mean_val = 0.00
        end 
        temp_array.push mean_val
      end
      my_hash = {}
      i = i + 1
      my_hash = {:key => j, :name => get_key(j), :data => temp_array, :color => 'url(#highcharts-default-pattern-1)'}
      r_array.push my_hash
      temp_array = []
    end
  
    return r_array
  end

  def format_usmle(in_data)
    usmle = []
    in_data.each do |data|
      data.each do |key, val|
        tmp_hash = {}
        temp_key = nil
        if key.include? "Step1PassFail"
          temp_key = 'Step 1 USMLE Exam (Pass/Fail)'
        elsif key.include? "Step1ExamScore"
          temp_key = "Step 1 USMLE Exam Score"
        elsif key.include? "Step1ExamDT"
          temp_key = "Step 1 USMLE Exam Date"
        elsif key.include? "CK01"
          temp_key = "Step 2 Clinical Knowledge Exam (Pass/Fail)"
        elsif key.include? "CK02"
          temp_key = "Step 2 Clinical Knowledge Exam Score"
        elsif key.include? "CK03"
          temp_key = "Step 2 Clinical Knowledge Exam Date"
        elsif key.include? "CS01"
          temp_key = "Step 2 Clinical Skill Exam Score"
        elsif key.include? "CS02"
          temp_key = "Step 2 Clinical Skill Exam Date" 
        else 
          temp_key = nil       
        end

        if !temp_key.nil?
          tmp_hash = {"#{temp_key}" => val}
          usmle.push tmp_hash
        end
      end
    end 
    return usmle

  end

  def hf_get_usmle in_survey
    #SA:Med18:National Board Licensing Exams:USMLE Exams
    rr = get_dataset(in_survey, "National Board Licensing Exams", "USMLE Exams")
    student_usmle = {}
    limegroups = rr.lime_survey.lime_groups
    limegroups.each do |grp|
        lq = grp.lime_questions
        col_name = get_col_name(lq, "StudentEmail")
        usmle_data = lq.first.dataset
        student_usmle = usmle_data.select {|rec| rec["#{col_name}"] == @pk}
        return format_usmle(student_usmle)
    end
  end 

end