module EpaReviewsHelper
  include WbaGraphsHelper

  WBA_DEF = {1 => "I did it",
             2 => "I talked them through it",
             3 => "I directed them from time to time",
             4 => "I was available just in case"}

  def hf_wba_instance_def(code)
    return WBA_DEF[code]
  end


end
