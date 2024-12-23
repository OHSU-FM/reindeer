module EpaReviewsHelper
  include WbaGraphsHelper

  WBA_DEF = {1 => "I did it",
             2 => "I talked them through it",
             3 => "I directed them from time to time",
             4 => "I was available just in case"}

   WBA_DEF2 = {1 => "Level 1",
               2 => "Level 2",
               3 => "Level 3",
               4 => "Level 4"}


  EPA_KEYWORDS = {
            "EPA1" => ["physical", "physical exams", "physical examinations", 'history', "exam", "physical exam", "examination", "interview", "information gathering", "H and P", "h&p"],
            "EPA2" => ["differential diagnosis", "differential", "differentials", "ddx"],
            "EPA3" => ["interpret", "interpreted", "cost-effective", "labs", "test", "screening test", "testing", "diagnostic", "assessment/plans",
                      "assessment", "plan"],
            "EPA4" => ["orders",  "prescription"],
            "EPA5" => ["document", "documentation", "note", "notes","progress note", "written",  "written H&P", "written history and physical", "discharge summary"], # "Document a clinical encounter in the patient record",
            "EPA6" => ["presentation", "presentations", "oral presentation", "oral case presentation","case presentation" ],   # "Provide an oral presentation of a clinical encounter",
            "EPA7" => ["clinical question", "evidence", "EBM", "literature"],  # "Form clinical questions and retrieve evidence to advance patient care",
            "EPA8" => ["handover", "handoff", "transition of care", "Signout", "hand offs", "sign offs", "sign outs"],  # "Give or receive a patient handover to transition care responsibility",
            "EPA9" => ["interprofessional", "collaborate", "multidisciplinary", "staff", "nurse"], # "Collaborate as a member of an interprofessional team",
            "EPA10" => ["urgent", "emergent", "CPR", "code", "rapid response"], #"Recognize a patient requiring urgent or emergent care and initiate evaluation and management",
            "EPA11" => ["consent", "informed consent", "shared decision making", "procedures", "shared decision"],  # "Obtain informed consent for tests and/or procedures",
            "EPA12" => ["procedure", "technical skills","technical", "IV", "venipuncture", "bladder catheterization", "bag-valve mask ventilation", "suture", "laceration repair"],  #"Perform general procedures of a physician ",
            "EPA13" => ["QI", "quality", "quality improvement", "safety", "patient safety", "project"] # "Identify system failures and contribute to a culture of safety and improvement"
  }

  EPA_COLORS = {
    "EPA1" => "#4AC24E",  #green shade
    "EPA2" => "#282CC2", # blue shade
    "EPA3" => "#8A18C2", # purple shade
    "EPA4" => "#ffc34d", # gold color
    "EPA5" => "#C21508", # red shade
    "EPA6" => "#FF00FF", # fushia
    "EPA7" => "#800000", # Maroon
    "EPA8" => "#7F00FF", # violet
    "EPA9" => "#72c2ce", # darker lightblue
    "EPA10" => "#FF7F50", # coral
    "EPA11" => "#40E0D0", # Turquoise
    "EPA12" => "#FF00FF", # Magneta
    "EPA13" => "#2B22AA" # indigo

  }

  EPA_DESC={"EPA1" => "Gather Hx and Perform PE",
            "EPA2" => "Prioritize DDx Following Clinical Encounter",
            "EPA3" => "Recommend and Interpret Common Dx and Screening Tests",
            "EPA4" => "Enter and Discuss Orders and Prescriptions",
            "EPA5" => "Document a Clinical Encounter in Pt Record",
            "EPA6" => "Provide Oral Presentation of a Clinical Encounter",
            "EPA7" => "Form Clinical Questions/Retrieve Evidence to Advance Pt care",
            "EPA8" => "Give or Receive a Pt Handover to Transition Care Responsibility",
            "EPA9" => "Collaborate as a member of IPE team",
            "EPA10" => "Recognize a Pt Requiring Urgent or Emergent Care and Initiate Evaluation and Management",
            "EPA11" => "Obtain Informed Consent for Tests/Procedures",
            "EPA12" => "Perform General Procedures of a Physician ",
            "EPA13" => "Identify System Failures/Contribute to a Cxof Safety/Improvement"
  }

  HIGHLIGHT_WORDS = ["presentation"]

  def hf_wba_instance_def(code)
    return WBA_DEF2[code]
  end

  def hf_epa_desc_with_color(epa_code)
    epa_desc = EPA_DESC[epa_code]
    epa_color = EPA_COLORS[epa_code]
    desc = '<span style="color:' + epa_color + '">' + epa_desc + '</span>'.html_safe
    return desc.html_safe
  end

  def hf_hightlight_all_epas comp
    comp.each do |cd|
      EPA_DESC.each do |key, value|

        keywords = EPA_KEYWORDS[key]
        epa_color = EPA_COLORS[key]
        epa_code = key
        if cd["mspe"].to_s != ""
          cd["mspe"] = cd["mspe"].gsub(/\b(#{keywords.join("|")})\b/i,
                  '<span style="color:' + "#{epa_color}" + '">' + "#{epa_code}: " + '<b>\1' +  '</span></b>')
        end
        if cd["feedback"].to_s != ""
          cd["feedback"] = cd["feedback"].gsub(/\b(#{keywords.join("|")})\b/i,
                  '<span style="color:' + "#{epa_color}" + '">' + "#{epa_code}: " + '<b>\1' +  '</span></b>')
        end
      end
    end
    return comp
  end

  def hf_highlight(text, epa_code)
    if epa_code == "N/A"
      return text
    elsif text.nil?
      return text.to_s
    end
    keywords = EPA_KEYWORDS[epa_code]
    epa_color = EPA_COLORS[epa_code]
    text_marked = text.gsub(/\b(#{keywords.join("|")})\b/i,
              '<span style="color:' + "#{epa_color}" + '">' + "#{epa_code}: " + '<b>\1' +  '</span></b>').html_safe

    return text_marked.html_safe
  end

  def hf_wba_str(wba)
    wba_str = ''
    for i in 0..3 do
          wba_str +=  hf_wba_instance_def(i+1) + ": #{wba[i]}" + "\r"
    end
    return wba_str
  end

  def hf_get_preceptor_assesses_data(user)
    precept_data = PreceptorAssess.where(user_id: user.id)
    if !precept_data.empty?
      return precept_data
    else
      precept_data = PreceptorEval.where(user_id: user.id)
      if !precept_data.empty?
        return precept_data
      else
        precept_data = hf_get_clinical_dataset(user, 'Preceptorship')
      end
    end
    return precept_data
  end

  # def hf_highlight(text, epa_code)
  #   if epa_code == "N/A"
  #     return text
  #   elsif text.nil?
  #     return text.to_s
  #   end
  #   keywords = EPA_KEYWORDS[epa_code]
  #   #text = highlight(text, [/\bpresentation\b/])
  #   text_marked = highlight(text, keywords.map{ |k| /\b#{k}\b/i })
  #   return text_marked.html_safe
  # end


end
