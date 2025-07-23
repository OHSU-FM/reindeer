module OverallProgressesHelper


  def init_epas

    temp_wbas = {}
    temp_wbas["EPA1A&1B"] = 0
    temp_wbas["EPA1A"] = 0
    temp_wbas["EPA1B"] = 0
    for i in 2..13 do
      temp_wbas["EPA#{i}"] = 0
    end

    return temp_wbas

  end


  def hf_compute_wba_epa(wbas_epas, new_competency)
#     temp_wbas = init_epas
#     wbas_epas.each do |key, value|
#       temp_wbas["#{key}"] = value
#     end

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
