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

  def hf_get_clinical_dataset(user, dataset_type)
    student_email = user.first.email
    surveys = surveygrps(user.first.permission_group_id)
    sid_clinical = surveys.select{|s| s if s.include? "#{dataset_type}"}.first.split("|").first
    rr = LimeSurvey.where(sid: sid_clinical).includes(:lime_groups)
    col_names = rr.first.column_names
    email_col = Hash[col_names]["StudentEmail"]
    results = get_data(sid_clinical, email_col, student_email)
    desired_data = reformat_data(Hash[col_names], results)

    return desired_data
  end

  def hf_get_csl_datasets(user, dataset_type)
    student_email = user.first.email
    surveys = surveygrps(user.first.permission_group_id)
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
      ["EPA"],
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

  def get_involvement_student(in_category, col_name, email)
    temp_hash = {}
    username = email.split("@").first

    in_category.each do |j|
        temp_involve = []
        (1..4).each do |k|
           #temp_data = Epa.where("#{col_name}": "#{j}", involvement: k).count
           temp_data = Epa.where("clinical_assessor = ? and involvement = ? and student_assessed like ? ", "#{j}", k, "%-#{username}").count
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

  def get_epa_involvement
    epa = {}
    (1..13).each do |j|
        temp_involve = []
        (1..4).each do |k|
           temp_data = Epa.where(epa: "EPA#{j}", involvement: k).count
           temp_involve.push temp_data
        end
        epa["EPA#{j}"] = temp_involve
    end
    return epa
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
       hash_data.store(:name, categories[i] + " - 0")
        hash_data.store(:y, [0])
       end
       hash_data.store(:color, random_color)
       pie_data.push hash_data

     end

     return pie_data

  end

  def hf_series_data_student(in_category, student_email)
    clinical_assessor = Epa.distinct.pluck(:clinical_assessor).sort
    clinical_assessor_hash = get_involvement_student(clinical_assessor, 'clinical_assessor', student_email)
    categories = clinical_assessor_hash.keys
    data_series = clinical_assessor_hash.values.transpose
    create_chart(data_series, in_category, categories)
  end


  def hf_series_data in_category
    categories = []
    data_series = []

    if in_category =="EPA"
      epa = get_epa_involvement
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

  def create_chart(data_series, in_category, categories)

  total_wba_count = 0

   data_series.each do |data|
     if !data.nil?
        total_wba_count += data.sum
      end
   end

    chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "<b>Work Based Assessment Datapoints - #{in_category}</b>" + '<br />Total # of WBAs: <b>' + total_wba_count.to_s + '</b>')
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
      f.series(name: "4 - I was available just in case", yAxis: 0, data: data_series[3], drilldown: "IwasAvailable")
      if in_category == "Clinical Assessor"
        pie_data = prep_data(categories, data_series)
        f.series(type: 'pie',
                name: 'Total No of DataPoints',
                data: pie_data,
                center: [920,80], size: 150, showInLegend: false
        )
      end

      f.drilldown(
        series: [{
          id: "IwasAvailable",
          data:[
              ['A', 4],
              ['B', 5],
              ['C', 6]

          ]
        }]
       )
      # ["#FA6735", "#3F0E82", "#1DA877", "#EF4E49"]
      f.colors(get_4_random_colors)

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

      #f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
      f.chart({
                defaultSeriesType: "column",
                width: 1400, height:600,
                plotBackgroundImage: ''
              })
    end

    return chart
  end

end
