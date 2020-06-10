module FomExamsHelper

COMPONENT_DESC = {'comp1_wk' => 'Component 1: Medical Knowledge (Weekly Tests/Quizzes)',
                  'comp2a_hss' => 'Component 2A: Clinical/Health Systems Science Skills Assessments',
                  'comp2b_bss' => 'Component 2B: Basic Science Skills Assessments',
                  'comp3_final' => 'Component 3: Final Block Exam',
                  'comp4_nbme' => 'Component 4: NBME Exam',
                  'comp5a_hss' => 'Component 5A: Clinical/Health Systems Science Skills Assessments',
                  'comp5b_bss' => 'Component 5B: Basic Science Skills Assessment',
                  'summary_comp' => 'Summary Data'
                }

BLOCKS = {  '1-FUND' => "Fundamentals",
            '2-BLHD' => "Blood & Host Defence",
            '3-SBM'  => "Skin, Bones & Musculature",
            "4-CPR"  => "Cardiopulmonary & Renal",
            "5-HODI" => "Hormones & Digestion",
            "6-NSF"  => "Nervous System & Function",
            "-DEVH" => "Developing Human"

}

  def hf_get_block_desc(in_code)
    return BLOCKS[in_code]
  end

  def hf_component_desc(in_code)
    return COMPONENT_DESC[in_code]
  end

  def hf_check_failed_comp(comp, failed_comps, coaching_type)

    str_warning = ""
    return str_warning if coaching_type == "student"
    failed_comps.each do |fcomp|
      if fcomp.include? comp
        return "glyphicon glyphicon-warning-sign"
      end
    end
    return str_warning
  end

  def hf_scan_failed_score(hash_components)
    failed_comp = []
    comp_keys = FomExam.comp_keys
    hash_components.each do |comp|
      comp_keys.each do |comp_key|
        value = comp.map{|key, value| value if key.include? comp_key and value.to_f < 70.0}.compact
        if !value.empty?
          failed_comp.push comp_key
        end
      end
    end

    return failed_comp

  end

  def check_pass_fail(data_series)
    fail_hash = {}
    new_series = []
    data_series.each do |score|
      if (score < 70 and score != 0.0)
        fail_hash = {y: score, color: "#FF6D5A"}
        new_series.push fail_hash
      elsif score == 0.0
        fail_hash = {y: nil}
        new_series.push fail_hash
      else
        new_series.push score
      end
    end
    return new_series
  end

  def hf_check_label_file(attachment_id)
    filename = ActiveStorage::Attachment.find(attachment_id).filename.to_s
    if filename.include? 'label'
      csv_table = CSV.parse(ActiveStorage::Attachment.find(attachment_id).download, headers: true, col_sep: "\t")
      json_string = csv_table.map(&:to_h).to_json
      label_hash = JSON.parse(json_string)
      permission_group_id = label_hash.first["permission_group_id"]
      course_code = label_hash.first["course_code"]
      if !course_code.blank?
        FomLabel.where(permission_group_id: permission_group_id, course_code: course_code).first_or_create.update(labels: json_string)
        return true
      end
    else
      return false
    end
  end

  def hf_create_graph(component, class_data, avg_data,  categories)

    student_name = class_data.first["full_name"]  # processing student Alver
    student_series = class_data.first.drop(2)  # removed the first 2 items in array
    student_series = student_series.map{|d| d.second.to_s.to_f if d.first.include? component}.compact

    #student_series = student_series[0..-3].map{|s| s.second.to_f} # removed the last 2 items in array
    student_series = check_pass_fail(student_series)
    class_mean_series = avg_data.first.map{|s| s.second.to_s.to_d.truncate(2).to_f if s.first.include? component}.compact
    selected_categories = categories.map {|key, val| val if key.include? component}.compact
    height = 400

    title =  hf_component_desc(component) + '<br ><b>' + student_name + '</b>'

    chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: title)
      #f.subtitle(text: '<br /><h4>Student: <b>' + student_name + '</h4></b>')
      f.xAxis(categories: selected_categories,
        labels: {
              style:  {
                          fontWeight: 'bold',
                          color: '#000000'
                      }
                }
      )
      f.series(name: "Student", yAxis: 0, data: student_series)
      f.series(name: "Class Mean", yAxis: 0, data: class_mean_series)

      # ["#FA6735", "#3F0E82", "#1DA877", "#EF4E49"]
      f.colors(["#7EFF5E", "#6E92FF"])

      f.yAxis [
         { tickInterval: 20,
           title: {text: "<b>Score (%)</b>", margin: 20}
         }
      ]
      f.plot_options(
        column: {
            dataLabels: {
                enabled: true,
                crop: false,
                overflow: 'none'
            }
        },
        series: {
          cursor: 'pointer'
        }
      )
      f.legend(align: 'center', verticalAlign: 'bottom', y: 0, x: 0)
      #f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
      f.chart({
                defaultSeriesType: "column",
                width: 1000, height: height,
                plotBorderWidth: 0,
                borderWidth: 0,
                plotShadow: false,
                borderColor: '',
                plotBackgroundImage: ''
              })
    end

    return chart
  end

end
