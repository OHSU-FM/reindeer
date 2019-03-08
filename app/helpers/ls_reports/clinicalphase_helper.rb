module LsReports::ClinicalphaseHelper
  include LsReportsHelper

  PRECEPTOR_COMP_DEF = { "Beginning" => "<b>Beginning</b>: Performs the attribute inconsistently; improvement is needed, or does not yet perform.",
                           "Effort" => "<b>Expending Effort</b>: Clearly trying to perform tasks.  Performs some aspects of the attribute consistently, but others aspects may not yet be skillful, complete, or accurate; the student demonstrates the attribute on some occasions.",
                           "Threshold" => "<b>Teetering at the Threshold</b>: Almost clerkship ready.  Performs most aspets of the attribute consistently; the student successfully demonstrates this attribute on the majority of occasions. ",
                           "Ready" => "<b>Ready for Clerkship</b>: Performs the attribute proficiently and reliably; the student consistently demonstrates this attribute."
  }

  DECODE_PRECEPTOR_COMP = { '1' => "Beginning",
                            '2' => "Effort",
                            '3' => "Threshold",
                            '4' => "Ready",
                            '888' => "Missing",
                            '' => "Missing"

  }

  BLOCKS = {  'FUND' => "Fundamentals",
              'BLHD' => "Blood & Host Defence",
              'SBM'  => "Skin, Bones & Musculature",
              "CARE" => "Cardiopulmonary & Renal",
              "CPR"  => "Cardiopulmonary & Renal",
              "HODI" => "Hormones & Digestion",
              "NSF"  => "Nervous System & Function",
              "DEVH" => "Developing Human"

  }

  COMP = { "SBP" => "Systems-Based Practice",
           "PBLI" => "Practice-Based Learning & Improvement",
           "PROF" => "Professionalism",
           "ICS" => "Interpersonal & Communication Skills",
           "PPPD" => "Professionalism and Personal & Professional Development",
           "SBPIC" => "Systems‐Based Practice and Interprofessional Collaboration"
  }

  GRAPH_COLOR = ["#8100ba", "#ff79c2", "#b52e2b", "#6cffb1", "#ff0066", "#fff631", "#6f9090"]

  class LimeTable < ActiveRecord::Base
  end


  def hf_decode_preceptor_comp(in_code)
      return DECODE_PRECEPTOR_COMP[in_code]
  end

  def hf_decode_comp(in_str)
    if in_str.include? "SBP1"
      return COMP["SBP"]
    elsif in_str.include? "PBL1"
      return COMP["PBLI"]
    elsif in_str.include? "PBLI"
      return COMP["PBLI"]
    elsif in_str.include? "PROF1"
      return COMP["PROF"]
    elsif in_str.include? "ICS1"
      return COMP["ICS"]
    elsif in_str.include? "PPPD"
      return COMP["PPPD"]
    elsif in_str.include? "SBPIC"
      return COMP["SBPIC"]
    else
      return "Invalid Preceptorship Competency Code"
    end
  end

  def hf_precetor_comp_def(in_code)
    return PRECEPTOR_COMP_DEF[in_code]
  end


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
    @student_year = temp_data.second
    return LimeSurveysLanguagesetting.find_by(surveyls_title: "SA:#{@student_year}:#{category}:#{dataset}")
  end

  def get_student_data(in_data, question, sub_question)
    #locate the hash pair and return the value
    score = in_data.first.select {|d| d["#{question.sid}X#{question.gid}X#{question.qid}#{sub_question.title}"]}.first.second
    score = score.to_s.to_d.truncate(2).to_f
    return score
  end

  def hf_get_all_blocks(in_survey, pk)
    comp = {}
    rr = get_dataset(in_survey, "Foundation of Medicine", "All Blocks (Graph View)")
    if rr.nil?
      return comp  ## return empty hash array
    end
    limegroups = rr.lime_survey.lime_groups
    #lq = limegroups.first.lime_questions
    student_email_col = rr.lime_survey.student_email_column

    #col_name = get_col_name(lq, "StudentEmail")
    comp_data = rr.lime_survey.dataset   #lq.first.dataset
    student_data = comp_data.select {|rec| rec["#{student_email_col}"] == @pk}
    if student_data.empty?
       return {}  # missing in graph  view dataset
    end

    limegroups.each do |grp|
        comp = {}

        grp.parent_questions.each do |pquestion|
          if !pquestion.title.include? "PersonalData"
            temp_comp = []
            pquestion.sub_questions.each do |sq|
              temp_comp.push get_student_data(student_data, pquestion, sq)
            end
            comp["#{pquestion.title}"] = temp_comp
          end       #return format_usmle(student_usmle)

        end
    end
    comp_data = nil
    lq = nil
    rr = nil
    return comp
  end

  def hf_get_all_blocks_class_mean(in_survey)
    rr = get_dataset(in_survey, "Foundation of Medicine", "All Blocks (Graph View)")
    role = RoleAggregate.find_by(lime_survey_sid: rr.surveyls_survey_id)
    fm_data = role.lime_survey.lime_stats.load_data
              #role.lime_survey.lime_groups.first.lime_questions.first.lime_stats.load_data

    class_mean = {}
    fm_data.each do |r_data|
      comp = []
      sb = r_data.sub_stats
      if !sb.empty?
          sb.each do |s|
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
    return r_array
  end

  def load_precept_data(in_q, in_d)
    temp_array = []
    i = 0
    in_q.each do |k|
      temp_hash = {}
      temp_hash = {k => in_d[i]}
      temp_array.push temp_hash
      i = i + 1
    end
    return temp_array
  end


  def get_student_precept(in_data, question, sub_question)
    #locate the hash pair and return the value
    if !sub_question.nil?
       return in_data.map {|d| d["#{question.sid}X#{question.gid}X#{question.qid}#{sub_question.title}"]}
    else
       return in_data.map {|d| d["#{question.sid}X#{question.gid}X#{question.qid}"]}
    end
  end

  def hf_get_preceptorship(in_survey, pk)
    rr = get_dataset(in_survey, "Foundation of Medicine", "Preceptorship")
    if rr.nil?
      return {}
    end

    limegroups = rr.lime_survey.lime_groups
    #lq = limegroups.first.lime_questions
    student_email_col = rr.lime_survey.student_email_column
    #col_name = get_col_name(lq, "StudentEmail")
    comp_data = rr.lime_survey.dataset  #lq.first.dataset
    student_data = comp_data.select {|rec| rec["#{student_email_col}"] == @pk}
    student_data = student_data.sort_by {|d| d["id"]}

    precept_hash = []

    limegroups.each do |lgroup|
      q_question = []
      q_data = []
      temp_comp = []
      lgroup.parent_questions.each do |pquestion|
        if !lgroup.group_name.include? "Personal Data"
          if !lgroup.group_name.include? "Preceptor Info"
              q_question = pquestion.sub_questions.map {|q|  q.question + " (#{q.title})" }
          else
              q_question = pquestion.sub_questions.map {|q|  q.question}
          end

          temp_comp = []
          if !pquestion.sub_questions.empty?
            pquestion.sub_questions.each do |sq|
              temp_comp.push get_student_precept(student_data, pquestion, sq)
            end
          else
            q_question = pquestion
            temp_comment = get_student_precept(student_data, pquestion, nil)

            temp_comp.push temp_comment.flatten
            q_question = []
            q_question.push pquestion.question
          end

          precept_hash.push load_precept_data(q_question, temp_comp)

        end
      end
    end

    return precept_hash

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


  def format_usmle(in_data)
    usmle = []
    data_array = []
    in_data.each do |data|
      data.each do |key, val|
        tmp_hash = {}
        data_array = []
        temp_key = nil
        if (key.include? "Step1PassFail") or (key.include? "RetestPF")
          temp_key = 'Step 1 USMLE Exam (Pass/Fail)'
        elsif (key.include? "Step1ExamScore") or (key.include? "RetestExamScore")
          temp_key = "Step 1 USMLE Exam Score" + " (" + hf_get_threshold("STEP1") + ")"
        elsif (key.include? "Step1ExamDT") or (key.include? "RetestExamDt")
          temp_key = "Step 1 USMLE Exam Date"
        elsif (key.include? "CKPassFail") or (key.include? "CK01") or (key.include? "CKPFRetest")
          temp_key = "Step 2 Clinical Knowledge Exam (Pass/Fail)"
        elsif (key.include? "CKExam") or (key.include? "CK02") or (key.include? "CKExamRetest")
          temp_key = "Step 2 Clinical Knowledge Exam Score" + " (" + hf_get_threshold("STEP2CK") + ")"
        elsif (key.include? "CKDT") or (key.include? "CK03") or (key.include? "CKDTRetest")
          temp_key = "Step 2 Clinical Knowledge Exam Date"
        elsif (key.include? "CSExam") or (key.include? "CS01") or (key.include? "CSExamRetest")
          temp_key = "Step 2 Clinical Skill Exam Score" + " (" + hf_get_threshold("STEP2CS") + ")"
        elsif (key.include? "CSDT") or (key.include? "CS02") or (key.include? "CSDTRetest")
          temp_key = "Step 2 Clinical Skill Exam Date"
        else
          temp_key = nil
        end

        if !temp_key.nil?
          data_array.push val
          tmp_hash = {"#{temp_key}" => data_array}
          usmle.push tmp_hash
        end
      end
    end
    # remove duplicate hash-key in usmle save the values in array format
    usmle = usmle.each_with_object({}) { |el, h| el.each { |k, v| h[k].nil? ? h[k] = v : h[k] = (Array.new([h[k]]) << v).flatten } }

    return usmle

  end

  def get_proper_code (course_name)
    course_code = course_name.gsub(/"|\[|\]/, '').split(" ").second
    case course_code
      when "770A"
        return "FAMP"
      when "770B"
        return "IMED"
      when  "770C"
        return "NEUR"
      when "770D"
        return "OBGY"
      when "770E"
        return "PEDI"
      when "770F"

        return "PSYC"
      when "770G"
        return "SURG"
      else
        return nil
    end
  end

  def hf_get_threshold (in_course_name)
    course_code = in_course_name.to_s.gsub(/"|\[|\]/, '').split(" ").first

    if course_code.to_s.include? "STEP"
      if  @student_year == "Med18"
         thres_score = Threshold.Med18.select {|s| s == course_code}.flatten.second
      elsif @student_year == "Med19"
         thres_score = Threshold.Med19.select {|s| s == course_code}.flatten.second
      elsif @student_year == "Med20"
         thres_score = Threshold.Med20.select {|s| s == course_code}.flatten.second
      elsif @student_year == "Med21"
          thres_score = Threshold.Med21.select {|s| s == course_code}.flatten.second
      elsif @student_year == "Med22"
          thres_score = Threshold.Med22.select {|s| s == course_code}.flatten.second
      end
      return thres_score.nil? ? "" : "Threshold: #{thres_score.to_s}"
    end
    if course_code == "INTS"
       course_code = get_proper_code(in_course_name)
    end
    # remove "[ ]" brackets
    if in_course_name.nil?
      thres_score = nil
      return thres_score.nil? ? "" : "(Passing Threshold: #{thres_score.to_s}) /"
    end
    course_number = in_course_name["770"]
    if course_number == "770"
      if @student_year == "Med18"
         thres_score = Threshold.Med18.select {|s| s == course_code}.flatten.second
      elsif @student_year == "Med19"
              thres_score = Threshold.Med19.select {|s| s == course_code}.flatten.second
      elsif @student_year == "Med20"
              thres_score = Threshold.Med20.select {|s| s == course_code}.flatten.second
      elsif @student_year == "Med21"
              thres_score = Threshold.Med21.select {|s| s == course_code}.flatten.second
      elsif @student_year == "Med22"
              thres_score = Threshold.Med22.select {|s| s == course_code}.flatten.second
      end
    else
      thres_score = nil
    end
    return thres_score.nil? ? "" : "(Passing Threshold: #{thres_score.to_s}) /"

  end

  def hf_get_usmle in_survey
    #SA:Med18:National Board Licensing Exams:USMLE Exams
    rr = get_dataset(in_survey, "National Board Licensing Exams", "USMLE Exams")
    student_usmle = {}
    if rr.nil?
      return {}
    end
    limegroups = rr.lime_survey.lime_groups
    limegroups.each do |grp|
        lq = grp.lime_questions
        col_name = get_col_name(lq, "StudentEmail")
        usmle_data = lq.first.dataset
        student_usmle = usmle_data.select {|rec| rec["#{col_name}"] == @pk}
        if student_usmle.empty?
          return {}
        end
        return format_usmle(student_usmle)
    end
  end

  def get_cpx_data student_cpx, key1, key2, data1, data2
    data = []
    if data2 == "Total Test"
      key = student_cpx.map{|k| k.keys}.first.select {|k| k.include? key1}
      val1 = student_cpx.map{|k| k[key[0]]}.first
      key = student_cpx.map{|k| k.keys}.first.select {|k| k.include? key2}
      val2 = student_cpx.map{|k| k[key[0]]}.first
      total_score = val1.to_i + val2.to_i
      data.push ""
      data1 = "<b>" + total_score.to_s + "</b>" + data1
      data.push data1
      if total_score.to_i >= 204
        data.push "P"
      else
        data.push "NP"
      end
      temp_hash = {}
      temp_hash = {data2 => data}
      return temp_hash
    elsif data2 == "Attachment"
          filecount_key = student_cpx.map{|k| k.keys}.first.select {|k| k.include? key1}
          filecount = student_cpx.map{|k| k[filecount_key[0]]}.first  ## no. of attachment
          rec_id = student_cpx.map{|k| k["id"]}.first  ## for the selected student
          sid = filecount_key.first.split("X").first
          q_id = filecount_key.first.split("X").last.split("_").first #split the string of ["961225X1049X12532_filecount"]
          file_key = filecount_key.first.split("_").first
          file_info = student_cpx.map{|k| k[file_key]}.first
          file_name = JSON(file_info).first["name"]
          temp_hash = {}
          data.push '<a href="/ls_files/' + sid.to_s + '/' + rec_id.to_s + '/' + q_id.to_s + '/' + file_name + '"' + ' target="_blank"' + '>' + file_name + '</a>'
          data.push "" # filler for cols
          data.push ""

          temp_hash = { data2 => data }
          return temp_hash
    end
#<a href="/ls_files/961225/1/12532/Ager,%20Emily%20CPX%20Performance.pdf">Ager, Emily CPX Performance.pdf</a>

    key = student_cpx.map{|k| k.keys}.first.select {|k| k.include? key1}
    val = student_cpx.map{|k| k[key[0]]}.first
    data.push val
    key = student_cpx.map{|k| k.keys}.first.select {|k| k.include? key2}
    val = student_cpx.map{|k| k[key[0]]}.first
    if key2 == "ICS5"
      data.push "<b>" + val.split(".").first + "</b>"+ "/152"
    elsif key2 == "CIS6"
      data.push "<b>" + val.split(".").first + "</b>"+ "/140"
    else
      data.push "<b>" + val + "</b>"
    end

    data.push data1
    temp_hash = {}
    temp_hash = {data2 => data}
    return temp_hash

  end

  def format_cpx student_cpx
    cpx = []
    cpx.push get_cpx_data(student_cpx, "CIS6", "ICS5", "/292", "Total Test")
    cpx.push get_cpx_data(student_cpx, "SEP1", "ICS5", "106/152", "Integrated Clinical Encounter (ICE)")
    cpx.push get_cpx_data(student_cpx, "SEP1", "CIS6", "98/140", "Communication & Interpersonal Skills (CIS)")
    cpx.push get_cpx_data(student_cpx, "SEP1", "SEP2", "P/NP", "Spoken English Proficiency (SEP)")
    cpx.push get_cpx_data(student_cpx, "PEE1", "PEE2", "P/NP", "Post Encounter Exercises")
    cpx.push get_cpx_data(student_cpx, "filecount", "", "", "Attachment")
    return cpx
  end

  def hf_get_cpx in_survey
    #SA:Med18:National Board Licensing Exams:USMLE Exams
    rr = get_dataset(in_survey, "Clinical Phase", "Clinical Performance Exam (CPX)")
    if rr.nil?
      return {}
    end
    student_cpx = {}
    student_data = []
    limegroups = rr.lime_survey.lime_groups
    limegroups.each do |grp|
        lq = grp.lime_questions
        col_name = get_col_name(lq, "StudentEmail")
        if !col_name.nil?
          cpx_data = lq.first.dataset
          student_cpx = cpx_data.select {|rec| rec["#{col_name}"] == @pk}
          if student_cpx.empty?
             return {}
          end
          student_data = format_cpx(student_cpx)
          return student_data

        end
    end
  end

 def load_attachments student_attach
   attach_array = []
   filecount_key = student_attach.map{|k| k.keys}.first.select {|k| k.include? "filecount"}
   filecount = student_attach.map{|k| k[filecount_key[0]]}.first  ## no. of attachment
   if filecount.to_s != ""
     rec_id = student_attach.map{|k| k["id"]}.first  ## for the selected student
     sid = filecount_key.first.split("X").first
     q_id = filecount_key.first.split("X").last.split("_").first #split the string of ["961225X1049X12532_filecount"]
     file_key = filecount_key.first.split("_").first
     file_info = student_attach.map{|k| k[file_key]}.first
     attachments = JSON(file_info)
     attachments.each do |attach|
       ls_file = '<a href="/ls_files/' + sid.to_s + '/' + rec_id.to_s + '/' + q_id.to_s + '/' + attach["name"] + '"' + ' target="_blank"' + '>' + attach["name"] + '</a>'
       attach_array.push ls_file
     end
     return attach_array
   else
     return []
   end
  end

  def hf_get_shelf_attachments in_survey
    rr = get_dataset(in_survey, "Clinical Phase", "Shelf Exam Score Reports")
    if rr.nil?
      return {}
    end
    shelf_attachments = []
    limegroups = rr.lime_survey.lime_groups
    limegroups.each do |grp|
        lq = grp.lime_questions
        col_name = get_col_name(lq, "StudentEmail")
        if !col_name.nil?
          student_data = lq.first.dataset
          student_attach = student_data.select {|rec| rec["#{col_name}"] == @pk}
          if student_attach.empty?
             return []
          end
          shelf_attachments = load_attachments(student_attach)
          return shelf_attachments
        end
    end
  end

  def hf_get_artifacts (pk)
    selected_user = User.find_by(email: pk)
    if selected_user.nil?
      return nil,0
    else
      no_docs = 0
      artifacts_student = Artifact.where(user_id: selected_user.id)
      official_docs = artifacts_student.select{|a| a.title == "Progress Board"}
      official_docs.each do |doc|
        no_docs = no_docs + doc.documents.count
      end
      return artifacts_student, no_docs
    end
  end

end
