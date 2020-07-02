module EpaReviewsHelper
  include WbaGraphsHelper

  WBA_DEF = {1 => "I did it",
             2 => "I talked them through it",
             3 => "I directed them from time to time",
             4 => "I was available just in case"}


  EPA_KEYWORDS = {
            "EPA1" => ["history", "exam", "physical exam", "examination", "interview", "information gathering", "H and P", "h&p"],
            "EPA2" => ["differential diagnosis", "differential", "differentials", "ddx"],
            "EPA3" => ["interpret", "cost-effective", "labs", "test", "screening test"],
            "EPA4" => ["orders",  "prescription"],
            "EPA5" => ["document", "documentation", "note", "notes","progress note", "written",  "written H&P", "written history and physical", "discharge summary"], # "Document a clinical encounter in the patient record",
            "EPA6" => ["presentation", "presentations", "oral presentation", "oral case presentation","case presentation" ],   # "Provide an oral presentation of a clinical encounter",
            "EPA7" => ["clinical question", "evidence", "patient care", "EBM", "literature"],  # "Form clinical questions and retrieve evidence to advance patient care",
            "EPA8" => ["handover", "handoff", "transition"],  # "Give or receive a patient handover to transition care responsibility",
            "EPA9" => ["team", "interprofessional", "collaborate", "multidisciplinary", "staff", "nurse"], # "Collaborate as a member of an interprofessional team",
            "EPA10" => ["urgent", "emergent", "CPR", "code", "rapid response"], #"Recognize a patient requiring urgent or emergent care and initiate evaluation and management",
            "EPA11" => ["informed consent", "shared decision making"],  # "Obtain informed consent for tests and/or procedures",
            "EPA12" => ["procedure", "technical skills","technical", "IV", "venipuncture", "bladder catheterization", "bag-valve mask ventilation", "suture", "laceration repair"],  #"Perform general procedures of a physician ",
            "EPA13" => ["QI", "quality", "quality improvement", "safety", "patient safety", "project"] # "Identify system failures and contribute to a culture of safety and improvement"
  }

  EPA_COLORS = {
    "EPA1" => "#4AC24E",  #green shade
    "EPA2" => "#282CC2", # blue shade
    "EPA3" => "#8A18C2", # purple shade
    "EPA4" => "#C24842", # orange shade
    "EPA5" => "#C21508", # red shade
    "EPA6" => "#FF00FF", # fushia
    "EPA7" => "#800000", # Maroon
    "EPA8" => "#7F00FF", # violet
    "EPA9" => "#00FFFF", # Cyan
    "EPA10" => "#FF7F50", # coral
    "EPA11" => "#E6E6FA", # Lilac
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
    return WBA_DEF[code]
  end

  def hf_epa_desc_with_color(epa_code)
    epa_desc = EPA_DESC[epa_code]
    epa_color = EPA_COLORS[epa_code]
    desc = '<span style="color:' + epa_color + '">' + epa_desc + '</span>'.html_safe
    return desc.html_safe
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
              '<span style="color:' + "#{epa_color}" + '"><b>\1</span></b>').html_safe

    return text_marked.html_safe
  end

  def hf_wba_str(wba)
    wba_str = ''
    for i in 0..3 do
          wba_str +=  hf_wba_instance_def(i+1) + ": #{wba[i]}" + "\r"
    end
    return wba_str
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
