module LsReports::AllblocksHelper


  def get_col_name(grp_questions, title)
     qq = grp_questions.select {|q| q.title = title}
     #{}"851468X295X3975StudentEmail"
     return "#{qq[0].sid}X#{qq[0].gid}X#{qq[0].qid}#{title}"
  end 

  def hf_format_data in_data
    comp = {"FUND"=> [], "BLHD" => [], "SBM" => [], "CARE" => [], "CPR" => [], "HODI" => [], "NSF" => [], "DEVH" => []}
    in_data.each do |data|
      data.each do |k, v|
        if k.include? "FUND"
            comp["FUND"].push v.to_s
        elsif k.include? "BLHD"
            comp["BLHD"].push v.to_s
        elsif k.include? "SBM"
            comp["SBM"].push v.to_s
        elsif k.include? "CARE"
            comp["CARE"].push v.to_s
        elsif k.include? "CPR"
            comp["CPR"].push v.to_s
        elsif k.include? "HODI"
            comp["HODI"].push v.to_s
        elsif k.include? "NSF"
            comp["NSF"].push v.to_s
        elsif k.include? "DEVH"
            comp["DEVH"].push v.to_s
        
        end 
      end
    end
    comp.reject! { |k, v| v.empty?}

    return comp
  end 

  def get_allblocks_dataset in_survey
    temp_data = in_survey.first.surveyls_title.split(":")
    student_year = temp_data.second
    category = "Foundations of Medicine"
    dataset = "All Blocks (Graph View)"

    #rr = RoleAggregate.find_by(lime_survey_sid: 851468)
    return LimeSurveysLanguagesetting.find_by(surveyls_title: "SA:#{student_year}:#{category}:#{dataset}")
  end

  def hf_get_all_blocks in_survey

    rr = get_allblocks_dataset(in_survey)
    allblocks = {}
    rr.lime_survey.lime_groups.each do |grp|
        lq = grp.lime_questions
        col_name = get_col_name(lq, "StudentEmail")
        allblocks = lq.first.dataset
        student_blocks = allblocks.select {|rec| rec["#{col_name}"] == @pk}
        return hf_format_data(student_blocks)
    end

  end

  def hf_get_all_blocks_class_mean in_survey
    rr = get_allblocks_dataset(in_survey)
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
              comp.push s.descriptive_stats.mean
          end
          class_mean["#{r_data.question.title}"] = comp
      end
    end
    fm_data = nil
    role = nil
    return class_mean
  end

end