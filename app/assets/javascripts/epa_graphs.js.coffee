
theme_light =
  colors: [
    '#7cb5ec'
    '#f7a35c'
    '#90ee7e'
    '#7798BF'
    '#aaeeee'
    '#ff0066'
    '#eeaaee'
    '#55BF3B'
    '#DF5353'
    '#7798BF'
    '#aaeeee'
  ]
  chart:
    backgroundColor: '#e8f4ea'
    style: fontFamily: 'sans-serif'
  title: style:
    fontSize: '16px'
    fontWeight: 'bold'
    textTransform: ''
  tooltip:
    borderWidth: 0
    backgroundColor: 'gray'
    shadow: false
  legend: itemStyle:
    fontWeight: 'bold'
    fontSize: '13px'
  xAxis:
    gridLineWidth: null
    labels: style: fontSize: '12px'
  yAxis:
    minorTickInterval: 'auto'
    title: style: textTransform: 'uppercase'
    labels: style: fontSize: '12px'


#======================================================================================================
get_epa_color = (k) ->
  COLORS = ['Salmon', 'AquaMarine', 'Plum', '#4d88ff', 'LawnGreen', '#7cb5ec', '#f7a35c', '#90ee7e', '#7798BF', '#aaeeee', '#ff0066', '#eeaaee', '#55BF3B']
  return COLORS[k]

#======================================================================================================
prepare_series_data = (in_data) ->

  series_data = []
  if in_data == undefined
    return []

  len = in_data.length
  i = 0
  while i < len
    #console.log ("while loop: " + JSON.stringify(in_data[i]))
    tempDate = in_data[i].x
    modDate = Date.parse(tempDate) - (24*60*60*1000)  # minus a day
    series_data[i] = {x: modDate, y: parseInt(in_data[i].y), evaluator: in_data[i].evaluator, discipline: in_data[i].discipline, setting: in_data[i].setting}
    i++
  #console.log("series_data: " + JSON.stringify(series_data))
  return series_data

#=========================================================================================================
#=========================================================================================================
get_drilldown = (epa_evaluators) ->

  drilldown_series = []
  if epa_evaluators == undefined
    return drilldown_series
  #this format --> [["Mejicano, George",3],["Bumsted, Tracy",4],["Bigioli, Frances",5]]
  len = epa_evaluators.length
  i = 0
  while i < len
    drilldown_series.push [epa_evaluators[i].assessor, epa_evaluators[i].count]
    i++

  return drilldown_series

#=========================================================================================================

yAxis_types = ->


  return [{
            gridLineWidth: 0,
            labels: {
              formatter: ->
                switch this.value
                  when 1 then return '1 - I did it'
                  when 2 then return '2 - I talked them through it'
                  when 3 then return '3 - I directed them from time to time'
                  when 4 then return '<b>4 - I was available just in case</b>'
                  else
                    return this.y;
              },
            min: 0,
            max: 4,
            title: {
                text: 'Evaluations'
            }
        }]

#======================================================================================================
build_options = (idx, in_data, render_to_target, graph_title, graph_sub_title, build_type, selected_dates) ->

  if build_type == "Individual"
    seriesArr = []
    name = "EPA" + idx
    seriesArr.push {name: name, data: prepare_series_data(in_data), color: get_epa_color(idx)}
    #seriesArr.push {name: "Class Mean", type: "scatter", marker: {symbol: 'diamond'}, pointWidth: 12, data: in_mean_data, color: "black"}
    #console.log("seriesArr:" + JSON.stringify(seriesArr))
    category = []
    category.push "EPA" + idx
    graph_title = "EPA" + idx + " - " + graph_title + "<br>" + "from " + selected_dates[0] + " to " + selected_dates[1]
    graph_type = 'spline'
    yAxis_params = yAxis_types
  else if build_type == 'Group'# All graphs
          seriesArr = []
          category = []
          i = 1;
          graph_title = graph_title + "<br>" + "from " + selected_dates[0] + " to " + selected_dates[1]
          graph_type = 'spline'
          yAxis_params = yAxis_types
          #console.log("yAxis_params: " + JSON.stringify(yAxis_types))
          while i <= 13  # 13 epas
            name = "EPA" + i
            temp_array = in_data[i]
            seriesArr.push {name: name, data: prepare_series_data(temp_array), color: get_epa_color(i)}
            category.push "EPA" + i
            i++

  return {
    #global: useUTC: false
    chart:
      renderTo: render_to_target
      type: graph_type
      plotBackgroundImage: ''
    title: text: graph_title
    subtitle: text: "<b>" + graph_sub_title + "</b>"

    rangeSelector:
        buttons: [{
            count: 3,
            type: 'month',
            text: '1M'
        }, {
            count: 6,
            type: 'month',
            text: '6M'
        }, {
            type: 'ytd',
            text: 'YTD'
        }],
        inputEnabled: false,
        selected: 2

    xAxis:
      categories: category
      type: 'datetime'
      dateTimeLabelFormats: month: '%b-%Y'   #ex- 01 Jan 2016
      tickInterval:24 * 3600 * 1000 * 7   #86400000 * 30
      title: text: 'Date of Observation'
      labels:
        enabled: true
        format: "{value:%Y-%m-%d}"

    yAxis: {
            gridLineWidth: 0,
            labels: {
                        formatter: ->
                          switch this.value
                            when 1 then return '<b>1 - I did it</b>'
                            when 2 then return '<b>2 - I talked them through it</b>'
                            when 3 then return '<b>3 - I directed them from time to time</b>'
                            when 4 then return '<b>4 - I was available just in case</b>'

                            else
                              return this.y;
                        },
            min: 0,
            max: 4,
            title: {
                text: 'Evaluations'
            }
        },
    tooltip: {
        useHTML: true
        xDateFormat: '%Y-%m-%d'
        shared: false # this has to be false if we have extra data in series data
        formatter: ->
                return 'Eval: ' + this.y + '<br>' + 'Date: ' + Highcharts.dateFormat('%Y-%m-%d', this.x) + '<br>' +
                'Discipline: ' + this.point.discipline + '<br>' + 'Setting: ' + this.point.setting + '<br>' + 'Evaluator: ' + this.point.evaluator
    }
    plotOptions: {
        series: {
          dataLabels: {
            enabled: true
            }
        }
    },
    series: seriesArr
  }

#======================================================================================================
build_options2 = (idx, in_data, render_to_target, graph_title, graph_sub_title, build_type, selected_dates, epa_evaluators) ->

  if in_data == undefined
    return

  if build_type = 'GroupCounts'
    seriesArr = []
    drilldownSeriesArr = []
    category = []
    i = 1;
    graph_title = graph_title + "<br>" + "from " + selected_dates[0] + " to " + selected_dates[1]
    graph_type = 'column'
    yAxis_params = yAxis_types
    while i <= 13  # 13 epas
      name = "EPA" + i
      temp_array = in_data[i]
      seriesArr.push {name: name, data: [{name: name, y: temp_array.length, drilldown: name}], color: get_epa_color(i)}
      drilldownSeriesArr.push {id: name, name: name, type: 'column', data: get_drilldown(epa_evaluators[name]), color: get_epa_color(i)}
      #[["Mejicano, George",3],["Bumsted, Tracy",4],["Bigioli, Frances",5]]
      category.push name
      i++

    #console.log("series_data: " + JSON.stringify(seriesArr))
    #drilldowns_series = [["Mejicano, George",3],["Bumsted, Tracy",4],["Bigioli, Frances",5]]

  return {
    #global: useUTC: false
    chart:
      renderTo: render_to_target
      type: graph_type
      plotBackgroundImage: ''
    title: text: graph_title
    subtitle: text: graph_sub_title
    xAxis:
      categories: category
      title: text: 'EPAs'
      #min: 0
      #type: 'category'
      labels:
        enabled: false

    legend:
      enabled: true
    yAxis: {
            gridLineWidth: 0,
            title: {
                text: 'Total # of Observations by EPA'
            }
        },
    plotOptions: {
        series: {
          grouping: true
          dataLabels: {
            enabled: true
            }
        }
    },
    series: seriesArr
    # drilldown: {
    #         series: drilldownSeriesArr
    #   }
  }

#=======================================================================================================
$(document).ready ->
    console.log("epa graphs!!")
    # $('div[data-user-id]' ).each ->
    #   userId = $(this).data('user-id')
    #   $(this).text(userId)
    #   console.log("userID:" + userId)

    return unless gon?

    #console.log ("after gon: " + JSON.stringify(gon.epa_adhoc))
    if gon.epa_adhoc == undefined or jQuery.isEmptyObject(gon.epa_adhoc)
      return
    @epa_adhoc_series_data = if gon.epa_adhoc? then gon.epa_adhoc else ''
    @epa_evaluators_series_data = if gon.epa_evaluators? then gon.epa_evaluators else ''
    @unique_evalutors = if gon.unique_evaluators? then gon.unique_evalutors else ''
    @selected_dates = if gon.selected_dates? then gon.selected_dates else ''
    @selected_student = if gon.selected_student? then gon.selected_student else ''

    window.chart2 = []
    i = 0
    for k of @epa_adhoc_series_data
      if @epa_adhoc_series_data.hasOwnProperty(k)
        i++
        graph_target = "data-visualization-EPA" + i
        console.log ("graph_target: " + graph_target)
        graph_title = "Work Based Assessment"
        graph_sub_title = @selected_student
        options = build_options(i, @epa_adhoc_series_data[i], graph_target, graph_title, graph_sub_title, "Individual", @selected_dates)
        window.chart2[i] = Highcharts.chart($.extend(true, null, theme_light, options))
        #window.chart2[i] = Highcharts.chart(options)

    #==== Display all Ad Hoc graphs
    graph_target = "data-visualization-AdHocAllEPAs"
    graph_title = "All Work Based Assessments"
    graph_sub_title = @selected_student
    options = build_options(0, @epa_adhoc_series_data, graph_target, graph_title, graph_sub_title, "Group", @selected_dates)
    window.chart3 = Highcharts.chart($.extend(true, null, theme_light, options))

    graph_target = "data-visualization-AdHocAllEPACount"
    graph_title = "Number of Observations Per WBA"
    graph_sub_title = @selected_student
    options = build_options2(0, @epa_adhoc_series_data, graph_target, graph_title, graph_sub_title, "GroupCounts", @selected_dates, @epa_evaluators_series_data )
    window.chart4 = Highcharts.chart($.extend(true, null, theme_light, options))
