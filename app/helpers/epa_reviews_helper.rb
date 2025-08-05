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
            "EPA3" => ["diagnostic assessment", "interpret", "interpreted", "cost-effective", "labs", "test", "screening test", "testing", "diagnostic", "assessment/plans",
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

  # NEW_EPA_KEYWORDS = {
  #           "EPA1A" => ["physical", "physical exams", "physical examinations", 'history', "exam", "physical exam", "examination", "interview", "information gathering", "H and P", "h&p"],
  #           "EPA1B" => ["physical", "physical exams", "physical examinations", 'history', "exam", "physical exam", "examination", "interview", "information gathering", "H and P", "h&p"],
  #           "EPA2" => ["differential diagnosis", "differential", "differentials", "ddx"],
  #           "EPA3" => ["interpret", "interpreted", "cost-effective", "labs", "test", "screening test", "testing", "diagnostic", "assessment/plans",
  #                     "assessment", "plan"],
  #           "EPA4" => ["orders",  "prescription"],
  #           "EPA5" => ["document", "documentation", "note", "notes","progress note", "written",  "written H&P", "written history and physical", "discharge summary"], # "Document a clinical encounter in the patient record",
  #           "EPA6" => ["presentation", "presentations", "oral presentation", "oral case presentation","case presentation" ],   # "Provide an oral presentation of a clinical encounter",
  #           "EPA7" => ["clinical question", "evidence", "EBM", "literature"],  # "Form clinical questions and retrieve evidence to advance patient care",
  #           "EPA8" => ["handover", "handoff", "transition of care", "Signout", "hand offs", "sign offs", "sign outs"],  # "Give or receive a patient handover to transition care responsibility",
  #           "EPA9" => ["interprofessional", "collaborate", "multidisciplinary", "staff", "nurse"], # "Collaborate as a member of an interprofessional team",
  #           "EPA10" => ["urgent", "emergent", "CPR", "code", "rapid response"], #"Recognize a patient requiring urgent or emergent care and initiate evaluation and management",
  #           "EPA11" => ["consent", "informed consent", "shared decision making", "procedures", "shared decision"]  # "Obtain informed consent for tests and/or procedures",
  # }

  # updated on 2/27/2025
  NEW_EPA_KEYWORDS = {
  "EPA1A" => ["histories", "hypothesis-driven history", "hypothesis driven history", "targeted history", "focused history", "directed history", "history taking", "medical history", "patient history", "clinical history", "history of present illness", "HPI", "review of systems", "ROS", "past medical history", "PMH", "interview", "information gathering"],
  "EPA1B" => ["physical exams", "physical exam", "physical examination", "examinations", "targeted exam", "focused physical", "directed physical", "tailored exam", "tailored physical", "clinical exam", "physical assessment", "body systems", "mental status", "H and P", "H&P"],
  "EPA2" => ["differential diagnosis", "prioritized differential", "differential", "ddx", "diagnosis", "prioritized list", "diagnostic possibilities", "rule out", "problem list", "clinical impression", "impression", "problem formulation"],

  "EPA3" => ["management plan", "management plans", "assessment and plans", "assessment and plan","interpret", "interpretation", "diagnostic testing", "screening test", "laboratory test", "lab test", "labs", "imaging", "test result", "diagnostic study", "radiology", "x-ray", "CT", "ultrasound", "MRI", "EKG", "ECG", "test interpretation", "normal values", "diagnostic assessment"],

  "EPA4" => ["orders", "order entry", "ordering", "prescription", "prescribe", "medication order", "drug order", "lab order", "imaging order", "test order", "consult order", "consultation request", "order set", "dosing", "dose", "frequency", "route", "duration", "refill", "e-prescribe"],

  "EPA5" => ["documentation", "medical record", "EMR", "EHR", "chart note", "note", "notes" "progress note", "SOAP note", "H&P", "history and physical", "written documentation", "admission note", "discharge summary", "procedure note", "clinic note", "inpatient note", "outpatient note", "consult note", "consultation note", "patient record"],

  "EPA6" => ["presentation", "presentations", "oral presentation", "case presentation", "clinical presentation", "patient presentation", "report", "verbal report", "bedside presentation", "presenting patient", "rounds presentation"],

  "EPA7" => ["literature", "evidence", "literature search", "evidence-based medicine", "EBM", "research", "clinical question", "PICO", "clinical evidence", "journal", "publication", "guideline", "clinical guideline", "systematic review", "meta-analysis", "randomized controlled trial", "RCT", "medical literature", "PubMed", "literature review", "clinical application"],

  "EPA8" => ["handover", "handoff", "hand-off", "sign out", "sign-out", "transition of care", "transfer of care", "patient transfer", "I-PASS", "SBAR", "transfer of information", "continuity of care", "care transition", "shift change", "coverage", "cross-coverage", "signout", "hand over", "pass the baton", "transfer of responsibility"],

  "EPA9" => ["interprofessional", "collaboration", "team-based care", "multidisciplinary", "interdisciplinary", "healthcare team", "care team", "team communication", "consultation", "nurse", "pharmacist", "social worker", "case manager", "physical therapist", "occupational therapist", "respiratory therapist", "team approach", "care coordination", "coordinated care", "team member"],

  "EPA10" => ["urgent", "emergent", "emergency", "critical", "rapid response", "code", "code blue", "deterioration", "unstable", "escalation", "escalate care", "decompensation", "triage", "patient safety", "immediate intervention", "life-threatening", "critical situation", "acute change", "resuscitation", "CPR", "ACLS", "BLS"],

  "EPA11" => ["shared decision making", "shared decision-making", "informed consent", "patient preference", "treatment options", "patient values", "risk communication", "benefit-risk", "risks and benefits", "patient autonomy", "patient education", "decision aid", "informed choice", "patient-centered", "patient centered", "preference-sensitive", "decision support", "joint decision"]
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

  NEW_EPA_COLORS = {
    "EPA1A" => "#4AC24E",  #green shade
    "EPA1B" => "#2B22AA", # indigo
    "EPA2" => "#282CC2", # blue shade
    "EPA3" => "#8A18C2", # purple shade
    "EPA4" => "#ffc34d", # gold color
    "EPA5" => "#C21508", # red shade
    "EPA6" => "#FF00FF", # fushia
    "EPA7" => "#800000", # Maroon
    "EPA8" => "#7F00FF", # violet
    "EPA9" => "#72c2ce", # darker lightblue
    "EPA10" => "#FF7F50", # coral
    "EPA11" => "#40E0D0" # Turquoise
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

  NEW_EPA_DESC={
            "EPA1A" => "Obtain a hypothesis-driven history",
            "EPA1B" => "Perform a tailored physical examination",
            "EPA2" => "Generate a prioritized differential diagnosis for a clinical encounter",
            "EPA3" => "Interpret Diagnostic or screening tests for a clinical encounter",
            "EPA4" => "Enter orders including prescriptions for a clinical encounter",
            "EPA5" => "Document a clinical encounter in the patient record",
            "EPA6" => "Provide an oral presentation of a clinical encounter",
            "EPA7" => "Use literature to make a patient care recommendation",
            "EPA8" => "Communicate a patient handover to transition responsibility of care",
            "EPA9" => "Advance patient care through interprofessional collaboration",
            "EPA10" => "Recognize a patient requiring urgent assessment and escalate care",
            "EPA11" => "Lead shared decision making discussions for patient care "

  }

  HIGHLIGHT_WORDS = ["presentation"]

  def hf_new_epa_keywords
    return NEW_EPA_KEYWORDS
  end

  def hf_new_epa_desc
    return NEW_EPA_DESC
  end

  def hf_epa_desc
    return EPA_DESC
  end

  def hf_wba_instance_def(code)
    return WBA_DEF2[code]
  end

  def hf_epa_desc_with_color(epa_code, new_competency)
    if new_competency # new epas
      epa_desc = NEW_EPA_DESC[epa_code]
      epa_color = NEW_EPA_COLORS[epa_code]
    else
      epa_desc = EPA_DESC[epa_code]
      epa_color = EPA_COLORS[epa_code]
    end
    desc = '<span style="color:' + epa_color + '">' + epa_desc + '</span>'.html_safe
    return desc.html_safe
  end

  def hf_hightlight_all_epas(comp, new_competency)

    if new_competency  # new epa
      epa_desc = hf_new_epa_desc
    else
      epa_desc = hf_epa_desc
    end

    comp.each do |cd|
      epa_desc.each do |key, value|

        if new_competency
          keywords = NEW_EPA_KEYWORDS[key]
          epa_color = NEW_EPA_COLORS[key]
        else
          keywords = EPA_KEYWORDS[key]
          epa_color = EPA_COLORS[key]
        end
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

    if @new_competency
      if epa_code == 'EPA1'  ## coming from csl_feedbacks table
        epa_code = 'EPA1A'
      end
      keywords = NEW_EPA_KEYWORDS[epa_code]
      epa_color = NEW_EPA_COLORS[epa_code]
    else
      keywords = EPA_KEYWORDS[epa_code]
      epa_color = EPA_COLORS[epa_code]
    end

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

  def hf_parse_ai_content(content)
    return "" if content.to_s == ""
    pos_index = content.index('Question-"')
    new_content = content[0..pos_index-1]
    question = content[pos_index..content.length]
    pos_index2 = question.index('<br />---')
    question = question[0..pos_index2-1]
    question = question.gsub('"', "").gsub("<br />", "")

    return new_content, question
  end

  def hf_parse_new_ai_content(content, ai_option)
    return "NO AI Data!" if content.to_s == ""

    if ai_option == 'google'
      pos_index = content.index('Google')
      #new_content = content[0..pos_index-1]
      if pos_index.nil?
        return "NO AI Data found!"
      else
        new_content = content[pos_index..content.length]
      end
    elsif ai_option == 'chatgpt'
      pos_index = content.index('ChatGPT')
      #new_content = content[0..pos_index-1]
      new_content = content[pos_index..content.length]
      #pos_index2 = question.index('<br />---')
      #question = question[0..pos_index2-1]
      #question = question.gsub('"', "").gsub("<br />", "")
    end

    return new_content
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
