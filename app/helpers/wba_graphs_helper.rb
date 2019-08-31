module WbaGraphsHelper

  # series: [{
  #   name: '1',
  #   data: [13 set of data points]
  # },{name: '2'
  #    data: [13 set of data points]
  # },{....}
  # ]

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
       hash_data.store(:name, categories[i])
       if !data_series[i].nil?
         hash_data.store(:y, mod_data_series[i].sum)
       else
        hash_data.store(:y, [0])
       end
       hash_data.store(:color, random_color)
       pie_data.push hash_data

     end

     return pie_data

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


    chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "<b>Work Based Assessment Datapoints - #{in_category}</b>" )
      f.xAxis(categories: categories)
      f.series(name: "1 - I did it", yAxis: 0, data: data_series[0])
      f.series(name: "2 - I talked them through it", yAxis: 0, data: data_series[1])
      f.series(name: "3 - I directed them from time to time", yAxis: 0, data: data_series[2])
      f.series(name: "4 - I was available just in case", yAxis: 0, data: data_series[3], drilldown: "IwasAvailable")
      if in_category == "Clinical Assessor"
        pie_data = prep_data(categories, data_series)
        f.series(type: 'pie',
                name: 'Total No of DataPoints',
                data: pie_data,
                center: [1000,100], size: 150, showInLegend: false
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
        series: {
          cursor: 'pointer'

        }
      )

      #f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
      f.chart({
                defaultSeriesType: "column",
                width: 1600, height:800,
                plotBackgroundImage: ''
              })
    end

    return chart

  end
end
