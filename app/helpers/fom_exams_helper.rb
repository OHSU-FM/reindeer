module FomExamsHelper

  def check_pass_fail(data_series)

    fail_hash = {}
    new_series = []
    data_series.each do |score|
      if (score < 70 and score != 0.0)
        fail_hash = {y: score, color: "#FF6D5A"}
        new_series.push fail_hash
      else
        new_series.push score
      end
    end


    return new_series
  end

  def hf_create_graph(class_data, avg_data,  categories)

    student_name = class_data.rows.first.first
    student_series = class_data.rows.first.drop(2)  # removed the first 2 items in array
    student_series = student_series[0..-3].map{|s| s.to_f} # removed the last 2 items in array
    student_series = check_pass_fail(student_series)
    class_mean_series = avg_data.rows.first.map{|s| s.to_d.truncate(2).to_f}

    categories = categories.map {|key, val| val if key.include? "comp1_wk"}.compact

    height = 400

    chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "<b>Component1 - Weekly MCQs</b>")
      f.subtitle(text: '<br />Student: <b>' + student_name + '</b>')
      f.xAxis(categories: categories,
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
