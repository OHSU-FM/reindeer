module WbaGraphsHelper

  # series: [{
  #   name: '1',
  #   data: [13 set of data points]
  # },{name: '2'
  #    data: [13 set of data points]
  # },{....}
  # ]


  def hf_series_data
    temp_data =  Epa.select("involvement, epa,  count(*)").group("involvement, epa").order("involvement, epa")
    categories = []
    data1 = []
    data2 = []
    data3 = []
    data4 = []
    hash_array = Hash.new
    categories = temp_data.select{|t| t.involvement==4}.map{|t| t.epa}
    temp_data.each do |data|
      #puts data.involvement.to_s + " " +  data.epa +  " " + data.count.to_s
      case data.involvement
        when 1
          data1.push data.count
        when 2
          data2.push data.count
        when 3
          data3.push data.count
        when 4
            data4.push data.count
        else
          puts "error -> " + data.involvement.to_s
      end
    end

    # hash_array["1"] = data1
    # hash_array["2"] = data2
    # hash_array["3"] = data3
    # hash_array["4"] = data4
    # json_array = []
    # hash_array.each do |hash|
    #   json_array << {"name": hash.first, "data": hash.second}
    # end

    chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "WBA Datapoints")
      f.xAxis(categories: categories)
      f.series(name: "1 - I did it", yAxis: 0, data: data1)
      f.series(name: "2 - I talked them through it", yAxis: 0, data: data2)
      f.series(name: "3 - I directed them from time to time", yAxis: 0, data: data3)
      f.series(name: "4 - I was available just in case", yAxis: 0, data: data4)
      f.yAxis [
         {title: {text: "No of Data Points", margin: 20} }
      ]

      #f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
      f.chart({defaultSeriesType: "column", plotBackgroundImage: '' })
    end

    return chart

  end
end
