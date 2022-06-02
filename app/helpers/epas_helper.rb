module EpasHelper

  def reformatted_data(results)
    epa_hash = {}
    #epa_hash = {"EPA1" => [], "EPA2" => [], "EPA3" => [], "EPA4" => [], "EPA4" => [], "EPA4" => [], "EPA5" => [], "EPA6" => []}
    json_object = results.to_json
    hash_object = JSON.parse(json_object)
    for i in 1..13 do
      selected_data = hash_object.select {|e| e if e["epa"] == "EPA#{i}"}
      selected_data = selected_data.sort_by {|s| s["submit_date"]}
      if !selected_data.nil?
        temp_array2 = []
        selected_data.each do |data|
          temp_array2 << {x: data["submit_date"], y: data["involvement"], evaluator: data["assessor_name"],
            discipline: data["clinical_discipline"], setting: data["clinical_setting"], epa: data["epa"]}
        end
        epa_hash[i] = temp_array2
      end
    end
    return epa_hash
  end

  def reformatted_data2(results)  ## this for packedBubble graph
    epa_hash = [{"name" => "Level1", "data" => []},
                {"name" => "Level2", "data" => []},
                {"name" => "Level3", "data" => []},
                {"name" => "Level4", "data" => []}
              ]

    for j in 1..4 do
      for i in 1..13 do
          count = 0
          count = results.select{|r| r if r.epa == "EPA#{i}" and r.involvement==j}.count
          if count != 0
            data_hash = {}
            data_hash.store("name", "EPA#{i}")
            data_hash.store("value", count)
            epa_hash[j-1]["data"].push data_hash
          end
      end
    end

   return epa_hash

  end

  def reformatted_data3(results)  #data for column, inverted & polar graphs

    epa_hash3 = {}
    for i in 1..13 do
        count = 0
        count = results.select{|r| r if r.epa == "EPA#{i}"}.count
        if count != 0

          epa_hash3.store("EPA#{i}", count)

        end
    end

    return epa_hash3
  end


  def epas_by_evaluators (results)
    epa_evaluators = {}
    selected_dates = []
    unique_evaluators = []
    unique_evaluators = results.pluck(:assessor_name).uniq
    selected_dates.push results.pluck(:submit_date).min.strftime("%Y-%m-%d")
    selected_dates.push results.pluck(:submit_date).max.strftime("%Y-%m-%d")

    json_object = results.to_json
    hash_object = JSON.parse(json_object)
    sorted_data = hash_object.sort_by {|e| [e["assessor_name"], e["submit_date"]]}
    i = 1
    while i <= 13 # 13 EPAs
      epa = "EPA" + i.to_s
      assessor_array = []
      unique_evaluators.each do |u|
        selected_data = sorted_data.select {|e| e if e["assessor_name"] == u and e["epa"] == epa}
        if selected_data.count != 0
          assessor_array << {assessor: u, count: selected_data.count}
          epa_evaluators["#{epa}"] = assessor_array
        end
      end
      i = i + 1
    end # end of while

    return epa_evaluators, unique_evaluators, selected_dates
  end

  def hf_get_epas (email)
    #selected_user = User.find_by(email: email)
    #epas = Epa.where(user_id: selected_user.id).order(:epa, :submit_date)
    epas = User.select(:id, :full_name).where(email: email).first.epas.order(:epa, :submit_date)

    if !epas.empty?
      total_wba_count = epas.count
      selected_student = epas.first.student_assessed.split("-").first
      #epa_hash = reformatted_data(epas)
      epa_hash = reformatted_data3(epas)
      epa_hash_dates = reformatted_data(epas)
      epa_evaluators, unique_evaluators, selected_dates = epas_by_evaluators(epas)
      return epas, epa_hash, epa_hash_dates, epa_evaluators, unique_evaluators, selected_dates, selected_student, total_wba_count
    else
      return [], {}, [], [], []
    end
  end
end
