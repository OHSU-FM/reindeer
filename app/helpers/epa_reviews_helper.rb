module EpaReviewsHelper
  include WbaGraphsHelper

  WBA_DEF = {1 => "I did it",
             2 => "I talked them through it",
             3 => "I directed them from time to time",
             4 => "I was available just in case"}


  EPA_KEYWORDS = {"EPA1" => ["history", "physical"],
            "EPA2" => ["diagnosis"],
            "EPA3" => ["diagnostic", "screening tests"],
            "EPA4" => ["discuss orders", "prescriptions"],
            "EPA5" => ["patient record"], # "Document a clinical encounter in the patient record",
            "EPA6" => ["presentation"],   # "Provide an oral presentation of a clinical encounter",
            "EPA7" => ["evidence", "patient care"], # "Form clinical questions and retrieve evidence to advance patient care",
            "EPA8" => ["patient handover", "transition care"],  # "Give or receive a patient handover to transition care responsibility",
            "EPA9" => ["collaborate"], # "Collaborate as a member of an interprofessional team",
            "EPA10" => ["urgent care", "emergent care", "evaluation"], #"Recognize a patient requiring urgent or emergent care and initiate evaluation and management",
            "EPA11" => ["consent", "test", "procedure"],  # "Obtain informed consent for tests and/or procedures",
            "EPA12" => ["perform", "procedure"],  #"Perform general procedures of a physician ",
            "EPA13" => ["system failures", "safety", "improvement"] # "Identify system failures and contribute to a culture of safety and improvement"
  }

  HIGHLIGHT_WORDS = ["presentation"]

  def hf_wba_instance_def(code)
    return WBA_DEF[code]
  end

  def hf_highlight(text, epa_code)
    if epa_code == "N/A"
      return text
    elsif text.nil?
      return text.to_s
    end
    keywords = EPA_KEYWORDS[epa_code]
    text_marked = text.gsub(/\b(#{keywords.join("|")})\b/i,
              '<span style="color:blue"><b>\1</span></b>').html_safe

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
