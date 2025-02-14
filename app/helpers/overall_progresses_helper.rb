module OverallProgressesHelper

  def hf_compute_wba_epa(wbas_epas, new_competency)

    tot_per = 0
    wbas_epas.each do |key, value|
      if value >= 2
        tot_per += 1.0
      elsif value == 1
        tot_per += 0.5
      end
    end
    if new_competency == true
      tot_per = (tot_per/12.0*100).round
    else
      tot_per = (tot_per/13.0*100).round
    end

    return tot_per
  end
end
