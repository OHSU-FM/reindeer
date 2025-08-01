module WbaGraphsHelper

  include LsReports::CompetencyHelper
  include LsReports::ClinicalphaseHelper
  include LsReports::SpreadsheetHelper

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

  COLORS = ['Salmon', 'AquaMarine', 'Plum', '#4d88ff', 'LawnGreen', '#7cb5ec', '#f7a35c', '#90ee7e', '#7798BF', '#aaeeee', '#ff0066', '#eeaaee', '#55BF3B']


  class LimeTable < ActiveRecord::Base
  end

  def hf_final_grade json_str
    begin

      arry = JSON.parse(json_str)
      long_str = ""
      arry.each do |key, value|
        key = key.gsub(":", " - ")
        long_str += "#{key}: #{value}</br>"
      end
      return long_str
    rescue
      return json_str
    end
  end

  def hf_epa_desc2(code)
    return EPA_DESC[code]
  end

  def fix_key(in_key)
    case in_key
        when "PPPD01"
          return "PPPD1"
        when "PPPD02"
          return "PPPD2"
        when "PPPD03"
          return "PPPD3"
        when "PPPD04"
          return "PPPD4"
        when "PPPD05"
          return "PPPD5"
        when "PPPD06"
          return "PPPD6"
        when "PPPD07"
          return "PPPD7"
        when "PPPD08"
          return "PPPD8"
        when "PPPD09"
          return "PPPD9"
        else
          return in_key

    end
  end

  def surveygrps(permission_group_id)
    surveys =  PermissionLsGroup.where(permission_group_id: permission_group_id).order(:updated_at)
    temp_surveys = []
    surveys.each do |survey|
      if survey.lime_survey.title.include? "Core Clinical/Electives/Intersessions"
        temp_surveys.push survey.lime_survey_sid.to_s + "|" + survey.lime_survey.title
      elsif survey.lime_survey.title.include? "Preceptorship"
        temp_surveys.push survey.lime_survey_sid.to_s + "|" + survey.lime_survey.title
      elsif survey.lime_survey.title.include? "CSL Narrative Assessment"
        temp_surveys.push survey.lime_survey_sid.to_s + "|" + survey.lime_survey.title
      elsif survey.lime_survey.title.include? "All Blocks"
        temp_surveys.push survey.lime_survey_sid.to_s + "|" + survey.lime_survey.title
      end
    end
    return temp_surveys
    #LimeSurveysLanguagesetting.where(surveyls_survey_id: survey.lime_survey_sid).first
  end

  def get_data(sid, col_name, student_email)
    results = []
    ActiveRecord::Base.logger = nil
    ActiveRecord::Base.transaction do
      LimeTable.table_name = "lime_survey_#{sid}"
      results = LimeTable.where("#{col_name}": student_email).order(:submitdate)
      return results
    end

  end

  def reformat_data (col_names, results)
    return [] if results.empty?
    rr = results.map(&:attributes)
    clinical_data = []
    rr.each do |rs|
      hash_data = {}
      rs.each do |key, val|
        new_key = col_names.select{|k, v| v == key}
        if !new_key.empty?
            new_key = new_key.first.first ## want the readable column
            #puts "#{new_key} --> " + val.to_s
            hash_data.store(fix_key(new_key), val)
         end
      end
      clinical_data.push hash_data
    end
    return clinical_data
  end

  def process_all_blocks(survey)
    comp = {}
    if survey.nil?
      return comp  ## return empty hash array
    end

    limegroups = survey.first.lime_groups # used where clause instead of find_by
    student_email_col = survey.first.student_email_column
    comp_data = survey.first.dataset
    student_data = comp_data.select {|rec| rec["#{student_email_col}"] == @pk}
    if student_data.empty?
       return {}, {} # missing in graph  view dataset
    end

    limegroups.each do |grp|
        comp = {}
        grp.parent_questions.each do |pquestion|
          if !pquestion.title.include? "PersonalData"
            temp_comp = []
            pquestion.sub_questions.each do |sq|
              temp_comp.push get_student_data(student_data, pquestion, sq)
            end
            comp["#{pquestion.title}"] = temp_comp
          end       #return format_usmle(student_usmle)

        end
    end
    comp_data = nil

    fm_data = survey.first.lime_stats.load_data

    class_mean = {}
    fm_data.each do |r_data|
      temp_comp = []
      sb = r_data.sub_stats
      if !sb.empty?
          sb.each do |s|
              temp_comp.push s.descriptive_stats.mean.to_s.to_d.truncate(2).to_f
          end
          class_mean["#{r_data.question.title}"] = temp_comp
      end
    end
    category_labels = fm_data[1].sub_stats.map{|d| d.q_text}
    fm_data = nil
    return comp, class_mean, category_labels
  end

  def cohort_title(permission_group_id)

    cohort_title = PermissionGroup.find(permission_group_id).title.split(" ").last.gsub(/[()]/, "")
    return cohort_title
    # case permission_group_id
    #   when 6
    #     return 'Med20'
    #   when 13
    #     return 'Med21'
    #   when 16
    #     return 'Med22'
    #   when 17
    #     return 'Med23'
    #   when 18
    #     return 'Med24'
    #   when 19
    #     return 'Med25'
    #   when 20
    #     return 'Med26'
    #   else
    #     return nil
    # end

  end

  def hf_get_clinical_dataset(user, dataset_type)
    student_email = user.email
    if !user.prev_permission_group_id.nil?
      cohort_title = cohort_title(user.prev_permission_group_id)
      surveys = surveygrps(user.prev_permission_group_id)
    else
      cohort_title = cohort_title(user.permission_group_id)
      surveys = surveygrps(user.permission_group_id)
    end
    if surveys.nil?
      return {}
    end

    if dataset_type == "All Blocks"
      sid_clinical = surveys.select{|s| s if s.include? "#{dataset_type}" and s.include? "#{cohort_title}"}
      return {} if sid_clinical.empty? or sid_clinical.nil?
      sid_clinical = sid_clinical.first.split("|").first
      rr = LimeSurvey.where(sid: sid_clinical).includes(:lime_groups)
      desired_data = process_all_blocks(rr)
      return desired_data
    else
      sid_clinical = surveys.select{|s| s if s.include? "#{dataset_type}"}
      if !sid_clinical.empty?
        sid_clinical = sid_clinical.first.split("|").first
        rr = LimeSurvey.where(sid: sid_clinical).includes(:lime_groups)
        col_names = rr.first.column_names
        email_col = Hash[col_names]["StudentEmail"]
        results = get_data(sid_clinical, email_col, student_email)
        desired_data = reformat_data(Hash[col_names], results)
        return desired_data
      else
        return {}
      end
    end
  end

  def hf_get_csl_datasets(user, dataset_type)
    student_email = user.email
    surveys = surveygrps(user.permission_group_id)
    csl_datasets = surveys.select{|s| s if s.include? "#{dataset_type}"} #.first.split("|").first
    big_data = []
    csl_datasets.each do |csl|
        csl_sid = csl.split("|").first
        csl_title = csl.split("|").last.split(":").last
        rr = LimeSurvey.where(sid: csl_sid).includes(:lime_groups)
        col_names = rr.first.column_names
        email_col = Hash[col_names]["StudentEmail"]
        results = get_data(csl_sid, email_col, student_email)
        if !results.empty?
          desired_data = reformat_data(Hash[col_names], results)
          desired_data.first.store("BlockName", csl_title)
          big_data.push desired_data
        end
    end
    return big_data
  end

  def hf_get_categories
    [
      ["EPA <= Med25"],
      ["EPA >= Med26"],
      ["Clinical Discipline"],
      ["Clinical Setting"],
      ["Clinical Assessor"],
      ["Top 10 Assessors"],
      ["Top 10 Student Assessed"],
    ]
  end

  def hf_get_wbas(user_id)
    epa = {}
    (1..13).each do |j|
        temp_involve = []
        (1..4).each do |k|
           temp_data = Epa.where(epa: "EPA#{j}", involvement: k, user_id: user_id).count
           temp_involve.push temp_data
        end
        epa["EPA#{j}"] = temp_involve
    end

    return epa
  end

  def get_involvement_student(in_category, col_name, user_id)
    temp_hash = {}
    #username = email.split("@").first
    if user_id.to_s.include? "@"
      email = user_id ## is an email
      user_id = User.find_by(email: email ).id
    end

    in_category.each do |j|
        temp_involve = []
        (1..4).each do |k|
           #temp_data = Epa.where("#{col_name}": "#{j}", involvement: k).count
           temp_data = Epa.where("clinical_assessor = ? and involvement = ? and user_id = ? ", "#{j}", k, user_id).count
           temp_involve.push temp_data
        end
        temp_hash["#{j}"] = temp_involve
    end

    return temp_hash
  end

  def get_involvement(in_category, col_name)
    temp_hash = {}
    in_category.each do |j|
        temp_involve = []
        (1..4).each do |k|
           temp_data = Epa.where("#{col_name}": "#{j}", involvement: k).count
           temp_involve.push temp_data
        end
        temp_hash["#{j}"] = temp_involve
    end
    return temp_hash
  end

  def get_extra_epas
    epa_codes_new_extra = []
    epa_codes_new_extra.push "EPA1A&1B"
    temp_epa_codes_new = hf_epa_codes_new
    epa_codes_new_extra = epa_codes_new_extra + temp_epa_codes_new
    epa_codes_new_extra.push "EPA12"
    epa_codes_new_extra.push "EPA13"
    return epa_codes_new_extra
  end

  def get_epa_involvement_by_student_assessed(user_id)
    #epa_student = Epa.where(user_id: user_id).group(:epa, :involvement).order(:epa).count
    return nil if user_id.nil?

    user = User.find(user_id)
    if user.permission_group_id <= 19  # <= Med25
      epa_codes = []
      (1..13).each do |j|
        epa_codes.push "EPA#{j}"
      end
    elsif user.permission_group_id >= 20 && user.permission_group_id <= 22 && user.new_competency  # Med26, Med27 & Med28
        epa_codes = get_extra_epas
    elsif user.permission_group_id >= 23 && user.new_competency  # >= Med29
        epa_codes = hf_epa_codes_new
    else
      epa_codes = []
      (1..13).each do |j|
        epa_codes.push "EPA#{j}"
      end    
    end
    epa_student = Epa.where(user_id: user_id).group(:epa, :involvement).order(:epa).count
    if epa_student.empty? or epa_student.nil?
       return nil
    end

    epa = {}
    epa_codes.each do |j|
        temp_involve = []
        (1..4).each do |k|
           temp_epa = "EPA" + j.to_s
           temp_data = epa_student[[temp_epa, k]]
           temp_involve.push temp_data
        end
        epa["EPA#{j}"] = temp_involve
    end
    return epa
  end

  def get_epa_involvement
    epa = {}
    (1..13).each do |j|
        temp_involve = []
        (1..4).each do |k|
           #count_involve = Epa.where(epa: "EPA#{j}", involvement: k).count
           count_involve = User.where("permission_group_id >= 16 and permission_group_id < 20").joins(:epas).where("epa=? and involvement=?", "EPA#{j}", k).count
           temp_involve.push count_involve
        end
        epa["EPA#{j}"] = temp_involve
    end
    return epa
  end

  def get_epa_involvement_new
    epa_hash = {}
    epa_codes_new_extra = []
    epa_codes_new_extra.push "EPA1A&1B"
    temp_epa_codes_new = hf_epa_codes_new
    epa_codes_new_extra = epa_codes_new_extra + temp_epa_codes_new
    epa_codes_new_extra.push "EPA12"
    epa_codes_new_extra.push "EPA13"

    epa_codes_new_extra.each do |epa|
        temp_involve = []
        (1..4).each do |k|
           #count_involve = Epa.where(epa: "EPA#{j}", involvement: k).count
           count_involve = User.where("permission_group_id >= 20 and permission_group_id <= 22").joins(:epas).where("epa=? and involvement=?", "#{epa}", k).count
           temp_involve.push count_involve
        end
        epa_hash[epa] = temp_involve
    end
    return epa_hash
  end


    #
    # [
    #     {name: categories[0], y: 486, color: '#63BBFF'},
    #     {name: categories[1], y: 281, color: '#96EB79'},
    #     {name: categories[2], y: 638, color: '#E363FF'}
    #   ],


  def random_color
    return "#" + "#{SecureRandom.hex(3)}"
  end

  def get_4_random_colors
    color_array = []
    for j in 0..3
      color_array.push "#" + "#{SecureRandom.hex(3)}"
    end
    return color_array
  end

  def prep_data(categories, data_series)
    pie_data = []
    mod_data_series = data_series.transpose
    for i in 0..categories.length-1
       hash_data = {}

       if !data_series[i].nil?
         hash_data.store(:name, categories[i])
         hash_data.store(:y, mod_data_series[i].sum)
       else
       hash_data.store(:name, categories[i])
        hash_data.store(:y, 0)
       end
       hash_data.store(:color, random_color)
       pie_data.push hash_data

     end

     return pie_data

  end

  def hf_series_data_student(in_category, user_id, pie_graph)  #params_id = could be email or user_id
    if in_category == "EPA"
      epas_hash = get_epa_involvement_by_student_assessed(user_id)
      if !epas_hash.nil?
        categories = epas_hash.keys
        data_series = epas_hash.values.transpose
        create_chart(data_series, in_category, categories)
      end
  #  elsif in_category == 'EPA >= Med26'

    elsif in_category == "Clinical Assessor"
      clinical_assessor = Epa.distinct.pluck(:clinical_assessor).sort
      clinical_assessor_hash = get_involvement_student(clinical_assessor, 'clinical_assessor', user_id)

      if clinical_assessor_hash.values.flatten.sum != 0
        categories = clinical_assessor_hash.keys
        data_series = clinical_assessor_hash.values.transpose
        if pie_graph
          create_pie_chart(data_series, categories)
        else
          create_chart(data_series, in_category, categories)
        end
      end
    end
  end


  def hf_series_data in_category
    categories = []
    data_series = []

    if in_category =="EPA <= Med25"
      epa = get_epa_involvement
      categories = epa.keys
      data_series = epa.values.transpose
    elsif in_category == 'EPA >= Med26'
      epa = get_epa_involvement_new
      categories = epa.keys
      data_series = epa.values.transpose

    elsif in_category == "Clinical Discipline"
          clinical_discipline = Epa.distinct.pluck(:clinical_discipline).sort
          clinical_discipline_hash = get_involvement(clinical_discipline, 'clinical_discipline')
          categories = clinical_discipline_hash.keys
          data_series = clinical_discipline_hash.values.transpose
    elsif in_category == "Clinical Setting"
          # temp_data =  Epa.select("involvement, clinical_setting, count(*)").group("involvement, clinical_setting").order("involvement, clinical_setting")
          # categories = temp_data.select{|t| t.involvement==4}.map{|t| t.clinical_setting}
          clinical_setting = Epa.distinct.pluck(:clinical_setting).sort
          clinical_setting_hash = get_involvement(clinical_setting, 'clinical_setting')
          categories = clinical_setting_hash.keys
          data_series = clinical_setting_hash.values.transpose

    elsif in_category == "Clinical Assessor"
          clinical_assessor = Epa.distinct.pluck(:clinical_assessor).sort
          clinical_assessor_hash = get_involvement(clinical_assessor, 'clinical_assessor')
          categories = clinical_assessor_hash.keys
          data_series = clinical_assessor_hash.values.transpose
          #User.find_by(username: 'graulty').epas.group(:clinical_assessor).count
          # => {"Attending Faculty"=>12, "Resident or Fellow"=>29, "Other/Not listed"=>16}
    elsif in_category == "Top 10 Assessors"
          array_hash ||= Epa.select(:involvement).group(:assessor_name).count
          sorted = array_hash.sort_by{|k,v| v}.reverse
          new_array = sorted[0..9]
          sorted = nil
          array_hash = nil
          assessor_name = new_array.transpose.first
          top_10_assessors = get_involvement(assessor_name, 'assessor_name')
          categories = top_10_assessors.keys
          data_series = top_10_assessors.values.transpose
      elsif in_category == "Top 10 Student Assessed"
          array_hash ||= Epa.select(:involvement).group(:student_assessed).count
          sorted = array_hash.sort_by{|k,v| v}.reverse
          new_array = sorted[0..9]
          sorted = nil
          array_hash = nil
          student_assessed = new_array.transpose.first
          top_10_student_assessed = get_involvement(student_assessed, 'student_assessed')
          categories = top_10_student_assessed.keys
          data_series = top_10_student_assessed.values.transpose

          # temp_data =  Epa.select("involvement, assessor_name, count(*)").group("involvement, assessor_name").order("involvement, assessor_name")
          # categories = temp_data.select{|t| t.involvement==4}.map{|t| t.assessor_name}
    end

    # [
    #       {name: categories[0], y: 486, color: '#63BBFF'},
    #       {name: categories[1], y: 281, color: '#96EB79'},
    #       {name: categories[2], y: 638, color: '#E363FF'}
    #     ]

    create_chart(data_series, in_category, categories)


  end

  def create_pie_chart(data_series, categories)
    total_wba_count = 0

     data_series.each do |data|
       if !data.nil?
          total_wba_count += data.map{|i| i.to_i}.sum
        end
     end

    chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "<b>Work Based Assessment Datapoints - Clinical Assessor</b>" + '<br />Total # of WBAs: <b>' + total_wba_count.to_s + '</b>')

        pie_data = prep_data(categories, data_series)
        f.series(type: 'pie',
                name: 'Total No of DataPoints',
                data: pie_data,
                center: [210,130], size: 160, showInLegend: false
        )


      # ["#FA6735", "#3F0E82", "#1DA877", "#EF4E49"]
      #f.colors(get_4_random_colors)
      f.set_options(
        color: ["#35FF84", "#B331E8", "#424EFF"]
      )

      f.plot_options(

        pie: {
            allowPointSelect: true,
            cursor: 'pointer',
            depth: 25,
            dataLabels: {
                enabled: true,
                crop: false,
                format: '<b>{point.name}</b>:<br>{point.percentage:.1f} %<br>value: {point.y}'
            }
        },

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
      f.chart({
                defaultSeriesType: "pie",
                plotBackgroundImage: '',
                type: 'pie',
                options3d: {
                  enabled: true,
                  alpha: 45,
                  beta: 0
                }
              })
    end

    return chart
  end

  def create_chart(data_series, in_category, categories)

    total_wba_count = 0

     data_series.each do |data|
       if !data.nil?
          total_wba_count += data.map{|i| i.to_i}.sum
        end
     end

     if in_category == "EPA"
       height = 400
       req_str = "<b>Requirement: At Least 2 WBAs for each EPA</b>"
     elsif in_category == "EPA <= Med25"
       height = 400
       req_str = "Note: WBAs for Med22 to Med25 only."
     elsif in_category == "EPA >= Med26"
       height = 400
       req_str = "Note: WBAs for Med26, Med27 & Med28 only"
     else
       height = 600
       req_str = "<b>Requirement: At Least 51 Attendings</b>"
     end

    chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "<b>Work Based Assessment Datapoints - #{in_category}</b>" + '<br />Total # of WBAs: <b>' + total_wba_count.to_s + '</b>' + "<br>" + req_str)
      #f.subtitle(text: '<br />Total # of WBAs: <b>' + total_wba_count.to_s + '</b>')
      f.xAxis(categories: categories,
              labels: {
                        style:  {
                                    fontWeight: 'bold',
                                    color: '#000000'
                                }
                      }
      )
      f.series(name: "1 - I did it", yAxis: 0, data: data_series[0])
      f.series(name: "2 - I talked them through it", yAxis: 0, data: data_series[1])
      f.series(name: "3 - I directed them from time to time", yAxis: 0, data: data_series[2])
      f.series(name: "4 - I was available just in case", yAxis: 0, data: data_series[3])


      if in_category == "Clinical Assessor"
        pie_data = prep_data(categories, data_series)


        f.series(type: 'pie',
                name: 'Total No of DataPoints',
                data: pie_data,
                center: [600,100], size: 150, showInLegend: false

        )
      end

      # ["#FA6735", "#3F0E82", "#1DA877", "#EF4E49"]
      #f.colors(get_4_random_colors)
      f.colors(["#FFBDB5", "#35FF84", "#B331E8", "#424EFF"])

      f.yAxis [
         { tickInterval: 20,
           title: {text: "<b>No of Data Points</b>", margin: 20}
         }
      ]
      f.plot_options(

        pie: {
            dataLabels: {
                enabled: true,
                crop: false,
                format: '<b>{point.name}</b>:<br>{point.percentage:.1f} %<br>value: {point.y}'
            }
        },

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
                width: 1300, height: height,
                plotBackgroundImage: ''
              })
    end

    return chart
  end

  #===========================================================================================================
  def get_epa_color(k)
      return COLORS[k]
  end


  def prepare_series_data(in_data)
    series_data = []
    if in_data.blank?
      return []
    end

    len = in_data.length
    i = 0

    while i < len
      #console.log ("while loop: " + JSON.stringify(in_data[i]))
      tempDate = in_data[i][:x]
      modDate = DateTime.parse(tempDate).strftime('%Q').to_i

      hash_items = {}
      hash_items.store('x', modDate)
      hash_items.store('y', in_data[i][:y].to_i)
      hash_items.store('evaluator', in_data[i][:evaluator])
      hash_items["discipline"] = in_data[i][:discipline]
      hash_items["setting"] = in_data[i][:setting]
      hash_items["epa"] = in_data[i][:epa]
      series_data << hash_items
      i = i + 1
    end
    #console.log("series_data: " + JSON.stringify(series_data))

    return series_data
  end

  def hf_create_wba_chart(epa_code, data_series, selected_dates, idx)

     total_wba_count = 0
     graph_title = "Work Based Assessment"
     #seriesArr = []
     #seriesArr << {name: epa_code, data: prepare_series_data(data_series), color: get_epa_color(idx)}
     #seriesArr.push {name: "Class Mean", type: "scatter", marker: {symbol: 'diamond'}, pointWidth: 12, data: in_mean_data, color: "black"}
     #console.log("seriesArr:" + JSON.stringify(seriesArr))
     category = []
     category.push epa_code
     graph_title = epa_code + " - " + graph_title + "<br>" + "from " + selected_dates[0] + " to " + selected_dates[1]
     total_wba_count = data_series.count


    chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "<b>Work Based Assessment Datapoints - #{category}</b>" + '<br />Total # of WBAs: <b>' + total_wba_count.to_s + '</b>')
      #f.subtitle(text: '<br />Total # of WBAs: <b>' + total_wba_count.to_s + '</b>')
      f.xAxis(
        categories: category,
        type: 'datetime',
        tickInterval: 24 * 3600 * 1000 * 7 ,
        dateTimeLabelFormats: {
          day: '%d %b %Y'
        },
        title: {
          text: 'Date of Observation'
        },
        labels: {
          enabled: true,
          format: "{value:%Y-%m-%d}",
          labels: {
                    style:  {
                                fontWeight: 'bold',
                                color: '#000000'
                            }
                  }
        }
      )
      f.series(name: epa_code, data: prepare_series_data(data_series), pointInterval: 24 * 3600 * 1000 * 7, color: get_epa_color(idx))


      # ["#FA6735", "#3F0E82", "#1DA877", "#EF4E49"]
      #f.colors(get_4_random_colors)

      f.yAxis [
         { tickInterval: 1,
           endonTick: false,
           min: 1,
           max: 4,
           title: {text: "<b>Assessment Type</b>", margin: 20}

         }
      ]

      f.tooltip(
          useHTML: true,
          xDateFormat: '%Y-%m-%d',
          shared: false # this has to be false if we have extra data in series data
      )

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
                defaultSeriesType: "spline",
                width: 1400, height: 400,
                plotBackgroundImage: ''
              })
    end


    return chart
  end

end
