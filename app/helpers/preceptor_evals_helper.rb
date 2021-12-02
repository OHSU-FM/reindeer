module PreceptorEvalsHelper

  COMP_CODES = ["ics", "pbli", "pppd", "sbpic"]
  DECODE_PRECEPTOR_COMP = { 1 => "Beginning",
                            2 => "Effort",
                            3 => "Threshold",
                            4 => "Ready",
                            888 => "Not Applicable",
                            999 => "Missing"
                          }

  def hf_decode_preceptor_comp3(in_code)
      return DECODE_PRECEPTOR_COMP[in_code]
  end

  def hf_background_color(in_code)
    case in_code
    when 4
      return "#A1FFB7"
    when 3
      return "#D8FF96"
    when 2
      return "#F1FF9C"
    when 1
      return "#FFB489"
    when 888
      return "#8CACEB"
    when 999
      return "#AF94FF"
    else ""
    end

  end


end
