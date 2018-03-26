
getObjects = (obj, key, val) ->
  objects = []
  for i of obj
    if !obj.hasOwnProperty(i)
      continue
    if typeof obj[i] == 'object'
      objects = objects.concat(getObjects(obj[i], key, val))
    else if i == key and obj[key] == val
      objects.push obj
  objects

parseComments = (competency_comment) ->
  temp_com = competency_comment.split("^")
  if temp_com[1] != undefined
    if temp_com[1] == "Comments: None"
        temp_com[0]
    else
        temp_com = temp_com[0] + "<hr> " + temp_com[1]
  else
    temp_com

select_color = (in_code) ->
  switch in_code
    when "ICS" then color = '#7cb5ec'
    when "MK" then color = '#f7a35c'
    when "PBLI" then color = '#f9c6c6'
    when "PCP" then color = '#7798BF'
    when "PPPD" then color = '#aaeeee'
    when "SBPIC" then color = '#eeaaee'
    else
      console.log ("Invalid code: " + in_code)
  color

get_series_data_nc = (series_data_hash, in_code, in_type) ->
  series_data = []
  for k of series_data_hash
    if series_data_hash.hasOwnProperty(k)
      if k.includes(in_code)
        if in_type == "student"
          series_data.push {y: series_data_hash[k],  color: '#d3d3d3'}
        else
          series_data.push {y: series_data_hash[k], color: 'black'}

  series_data


get_series_data = (series_data_hash, in_code, in_type) ->
  series_data = []
  for k of series_data_hash
    if series_data_hash.hasOwnProperty(k)
      if k.includes(in_code)
        if in_type == "student"
          selected_color = select_color(in_code)
          series_data.push {y: series_data_hash[k], color: selected_color}
        else
          series_data.push {y: series_data_hash[k], color: 'black'}

  series_data

get_all_series_data_nc = (series_data_hash, in_type) ->
  series_data = []
  for k of series_data_hash
    if series_data_hash.hasOwnProperty(k)
          series_data.push {y: series_data_hash[k],  color: '#d3d3d3'}
    else
      series_data.push series_data_hash[k]
  series_data

get_all_series_data = (series_data_hash, in_type) ->
  series_data = []
  for k of series_data_hash
    if series_data_hash.hasOwnProperty(k)
      if in_type =="student"
        if k.includes('ICS')
          series_data.push {y: series_data_hash[k], color:'#7cb5ec'}
        else if k.includes('MK')
          series_data.push {y: series_data_hash[k], color:select_color("MK")}
        else if k.includes('PBLI')
          series_data.push {y: series_data_hash[k], color:select_color("PBLI")}
        else if k.includes('PCP')
          series_data.push {y: series_data_hash[k], color:select_color("PCP")}
        else if k.includes('PPPD')
          series_data.push {y: series_data_hash[k], color:select_color("PPPD")}
        else if k.includes('SBPIC')
          series_data.push {y: series_data_hash[k], color:select_color("SBPIC")}
        else
          console.log ('found else: ' + k)
          series_data.push series_data_hash[k]

      else
        series_data.push series_data_hash[k]
  series_data

get_allblocks_color = (k) ->
  if k.includes('Comp1')
    return 'Salmon'
  else if k.includes('Comp2')
    return 'AquaMarine'
  else if k.includes('Comp3')
    return 'Plum'
  else if k.includes('Comp4')
    return 'Khaki'
  else if k.includes('Comp5')
    return 'LawnGreen'
  else
    console.log ('found else: ' + k)

get_desc = (k) ->
  if k.includes('Comp1')
    return 'Component 1 - Weekly Tests/Quizzes'
  else if k.includes('Comp2')
    return 'Component 2 - Skills Assessments'
  else if k.includes('Comp3')
    return 'Component 3 - OHSU Final Block Exam'
  else if k.includes('Comp4')
    return 'Component 4 - NBME Exam'
  else if k.includes('Comp5')
    return 'Component 5 - Final Skills Exam'
  else
    console.log ('found else: ' + k)


get_options = (series_data_1, series_data_1_nc, series_data_2, graph_title, graph_sub_title, series_data_name_1, series_data_name_2, render_to_2, graph_type, xAxis_category) ->
  show_legend_1 = true
  show_legend_2 = true
  return {
    chart: renderTo: render_to_2
    title: text: graph_title
    subtitle: text: graph_sub_title
    xAxis:
      categories: xAxis_category

    colors: [
      '#aaeeee'
      '#d3d3d3'
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
    yAxis: [{
            labels: {
                format: '{value}%',
                style: {
                    color: Highcharts.getOptions().colors[1]
                }
            },
            min: 0
            max: 100
            title: {
                text: 'Percent',
                style: {
                    color: Highcharts.getOptions().colors[1]
                }
            }
        }, {
            title: {
                text: '',
                style: {
                    color: Highcharts.getOptions().colors[0]
                }
            },
            min: 0
            max: 100
            labels: {
                format: '{value}%',
                style: {
                    color: Highcharts.getOptions().colors[0],
                    display:'none'
                }
            },
            opposite: true
        }],
    tooltip: {
        shared: true
    },
    plotOptions: {
        series: {
          pointPadding: 0,
          groupPadding: 0
        }
    },
    series: [{
    name: 'Clinical Courses',
    type: 'column',
    data: series_data_1,
    tooltip: {
        valueSuffix: '%'
    }
    }, {
        name: 'Non-Clinical Courses',
        type: 'column',
        data: series_data_1_nc,
        tooltip: {
          valueSuffix: '%'
          formatter: ->
              return '<b>'+ this.x +'</b>' + '<br/><span style="color:'+ this.point.series.color +'"> ' + this.point.series.name + ': ' + this.y+'%</span>';

        }

    }, {
        type: 'scatter'
        color: 'black'
        marker: { symbol: 'diamond' }
        name: series_data_name_2
        colorByPoint: false
        data: series_data_2
        showInLegend: show_legend_2
        tooltip: {
            valueSuffix: '%'
        },
        legend: {
          itemStyle: {
                      width:'200px',
                      textOverflow: 'ellipsis',
                      overflow: 'hidden',
                      font: '10px Helvetica'
                     }
        }
    }]
    }

get_desc2 = (in_data) ->
  $.each in_data, (key, val) ->
    console.log "key: " + key + " ---> val: " + val
    if key == "Term"
      return val

normalize = (val) ->
  for i of val
    if val[i] == '888'
      val[i] = 0
    else if val[i] == '999'
      val[i] = 0
    else
      val[i] = val[i] * 1

  return val

reformat_in_data = (in_data) ->
  new_array = []
  sm_array = []
  i = 0
  console.log ("in_data Length: ") + in_data.length
  while (i < 3)
    sm_array = []
    j = 0
    while (j < 4)
      console.log ("in_data: j=" + j + "-> "  + in_data[j][i])
      sm_array.push in_data[j][i]
      j = j + 1
    new_array.push sm_array
    i = i + 1
  console.log ("new_array: " + new_array)
  return new_array


build_options_precept = (idx, in_data, in_mean_data, in_categories, render_to_2, graph_title, graph_sub_title) ->
  seriesArr = []
  console.log "in_data: " + in_data
  series_names = in_categories #contains preceptorship terms

  arry_categories = []
  #arry_categories = in_categories

  temp_array = []
  new_array = []
  for item of in_data
    $.each in_data[item], (key, value) ->
      arry_categories.push key
      temp_array.push value
  console.log "temp_array: " + temp_array
  new_array = reformat_in_data(temp_array)

  console.log "--> " + "new_array length: " + new_array.length

  i = 0
  while (i < new_array.length)
    console.log "new_array[i]: " + i + " --> " + new_array[i]
    seriesArr.push {name: series_names[i], type: "bar", pointWidth: 24,  data: normalize(new_array[i])}
    i = i + 1

      # the line of code below works well but not quite what we want
      ##seriesArr.push {name: key, type: "bar", pointWidth: 24,  data: normalize(normalize(val))}
      #seriesArr.push {name: "Class Mean", type: "scatter", marker: {symbol: 'diamond'}, pointWidth: 12, data: in_mean_data, color: "black"}

  show_legend_1 = true
  show_legend_2 = true

  return {
    chart: renderTo: render_to_2
    title: text: graph_title
    subtitle: text: graph_sub_title
    xAxis:
      categories: arry_categories
      tickInterval: 1
      labels:
        enabled: true
        formatter: ->
           return this.value;
    colors: [
      '#aaeeee'
      '#d3d3d3'
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
    yAxis: [{
            labels: {
                format: '{value}',
                style: {
                    color: Highcharts.getOptions().colors[1]
                }
            },
            min: 0
            max: 16
            title: {
                text: 'Beginning -> Expending Effort -> Threshold -> Ready'
                style: {
                    color: Highcharts.getOptions().colors[2]
                }
            }
        }, {
            title: {
                text: '',
                style: {
                    color: Highcharts.getOptions().colors[3]
                }
            },
            min: 0
            max: 16
            labels: {
                format: '{value}',
                style: {
                    color: Highcharts.getOptions().colors[4],
                    display:'none'
                }
            },
            opposite: true
        }],
    tooltip: {
        shared: true
    },
    plotOptions: {
        series: {
          stacking: 'normal',
          dataLabels: {
            enabled: true,
            formatter: ->
              switch this.y
                when 1 then return "Beginning=" + this.y
                when 2 then return "Effort=" + this.y
                when 3 then return "Threshold=" + this.y
                when 4 then return "Ready=" + this.y
                when 0 then return "Not Able to Assess=" + this.y
                else
                  return this.y;
            },
          pointPadding: 0.2,
          groupPadding: 0.1
        }
    },
    series: seriesArr
  }

build_options = (idx, in_data, in_mean_data, render_to_2, graph_title, graph_sub_title) ->

  seriesArr = []

  console.log ("build_options -> in_data: " + in_data)

  seriesArr.push {name: get_desc(idx), type: "column", pointWidth: 12,  data: in_data, color: get_allblocks_color(idx)}
  seriesArr.push {name: "Class Mean", type: "scatter", marker: {symbol: 'diamond'}, pointWidth: 12, data: in_mean_data, color: "black"}

  show_legend_1 = true
  show_legend_2 = true

  return {
    chart: renderTo: render_to_2
    title: text: graph_title
    subtitle: text: graph_sub_title
    xAxis:
      categories: ["FUND", "BLHD", "SBM", "CPR", "HODI", "NSF", "DEVH" ]
      tickInterval: 1
      labels:
        enabled: true
        formatter: ->
           return this.value;
    colors: [
      '#aaeeee'
      '#d3d3d3'
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
    yAxis: [{
            labels: {
                format: '{value}%',
                style: {
                    color: Highcharts.getOptions().colors[1]
                }
            },
            min: 0
            max: 100
            title: {
                text: 'Percent',
                style: {
                    color: Highcharts.getOptions().colors[2]
                }
            }
        }, {
            title: {
                text: '',
                style: {
                    color: Highcharts.getOptions().colors[3]
                }
            },
            min: 0
            max: 100
            labels: {
                format: '{value}%',
                style: {
                    color: Highcharts.getOptions().colors[4],
                    display:'none'
                }
            },
            opposite: true
        }],
    tooltip: {
        shared: true
    },
    plotOptions: {
        series: {
          pointPadding: 0.2,
          groupPadding: 0.1
        }
    },
    series: seriesArr
  }

create_graph = (graph_target, xAxis_category, series_data_hash, series_data_hash_nc,comp_class_mean_hash, in_code, in_series_name) ->
  date = new Date()
  new_date = "As of Date: " + (date.getMonth()+1) + "/" + date.getDate() + "/" + date.getFullYear()
  render_to_2 = graph_target
  show_legend_1 = true
  show_legend_2 = true          #series_data_2 = "Null"
  graph_type = "column"

  if in_code == 'all-comp'
    series_data_1 = get_all_series_data(series_data_hash, "student")
    series_data_2 = get_all_series_data(comp_class_mean_hash, "student")
    graph_title = "Student Attainment of Required Number of Entrustable Milestones by UME Competency."
    graph_sub_title = "<b>% Complete - " + new_date + "</b>"
    series_data_1 = series_data_2
    series_data_2 = "Null"
    show_legend_2 = false          #series_data_2 = "Null"
    series_data_name_1 = "Class Mean"
    series_data_name_2 = ""
    options = get_options(series_data_1, series_data_1_nc, series_data_2, graph_title, graph_sub_title, series_data_name_1, series_data_name_2, render_to_2, graph_type, xAxis_category)
    window.chart2 = Highcharts.chart($.extend(true, null, theme_light, options))
  else if in_code == 'student'
    series_data_1 = get_all_series_data(series_data_hash, "student")
    series_data_1_nc = get_all_series_data_nc(series_data_hash_nc, "student")
    series_data_2 = get_all_series_data(comp_class_mean_hash, "mean")
    graph_title = new_date + " (" + in_series_name + ")"
    graph_sub_title = "<b>% Complete</b><br /><b>* Grey bar indicates tracked competency without meeting the clinical context requirement for entrustability.</b><br/>
<b>For a complete list of competencies that meet this criteria, please refer to pp. 51-52 of the Student Handbook.</b>"

    series_data_name_1 = in_series_name
    series_data_name_2 = "Class Mean"
    options = get_options(series_data_1, series_data_1_nc, series_data_2, graph_title, graph_sub_title, series_data_name_1, series_data_name_2, render_to_2, graph_type, xAxis_category)
    window.chart2 = Highcharts.chart($.extend(true, null, theme_light, options))
  else if in_code == 'allblocks'
    #data = series_data_hash
    #mean_data = comp_class_mean_hash

    graph_title = new_date + " (" + in_series_name + ")"
    graph_sub_title = "<b>ALL BLOCK</b>"
    i = 0
    window.chart2 = []
    $.each series_data_hash, (key, val) ->
      console.log ("key: " + key)
      console.log ('val: ' + val)
      data = val
      mean_data = comp_class_mean_hash[key]
      graph_target = "data-visualization-" + key
      options = build_options(key, data, mean_data, graph_target, graph_title, graph_sub_title)
      window.chart2[i] = Highcharts.chart($.extend(true, null, theme_light, options))
      i = i + 1
  else if in_code == 'preceptorship'
    graph_title = new_date + " (" + in_series_name + ")"
    graph_sub_title = "<b>Preceptorship Evaluations</b>"
    mean_data = ''
    i = 1
    window.chart3 = []
    categories = series_data_hash[0][3]["Term"]
    while i <= 4
        data = series_data_hash[i]
        graph_target = "data-visualization-" + i
        #categories = []
        #for item of data
        #  $.each data[item], (key, val) ->
        #    console.log "key : " + key + " val: " + val
        #    categories.push key

        options = build_options_precept(i, data, mean_data, categories, graph_target, graph_title, graph_sub_title)
        window.chart3[i] = Highcharts.chart($.extend(true, null, theme_light, options))
        i = i + 1
  else
    series_data_1 = get_series_data(series_data_hash, in_code, "student")
    series_data_1_nc = get_series_data_nc(series_data_hash_nc, in_code, "student")
    series_data_2 = get_series_data(comp_class_mean_hash, in_code, "mean")
    graph_title = "Domain: " + in_code + " (" + in_series_name + ")"
    graph_sub_title = "<b>% Complete - " + new_date + "</b>"
    series_data_name_1 = in_series_name
    series_data_name_2 = "Class Mean"
    options = get_options(series_data_1, series_data_1_nc, series_data_2, graph_title, graph_sub_title, series_data_name_1, series_data_name_2, render_to_2, graph_type, xAxis_category)
    window.chart2 = Highcharts.chart($.extend(true, null, theme_light, options))

theme_dark =
      colors: [
        '#6a00d9'
        '#2b908f'
        '#90ee7e'
        '#f45b5b'
        '#7798BF'
        '#aaeeee'
        '#ff0066'
        '#eeaaee'
        '#55BF3B'
        '#DF5353'
        '#7798BF'
        '#aaeeee'
        '#ffff02'
        '#a32a00'
      ]
      chart:
        backgroundColor:
          linearGradient:
            x1: 0
            y1: 0
            x2: 1
            y2: 1
          stops: [
            [
              0
              '#2a2a2b'
            ]
            [
              1
              '#3e3e40'
            ]
          ]
        style: fontFamily: 'sans-serif'
        plotBorderColor: '#606063'
      title: style:
        color: '#E0E0E3'
        textTransform: 'none'
        fontSize: '20px'
      subtitle: style:
        color: '#E0E0E3'
        textTransform: 'none'
      xAxis:
        gridLineColor: '#707073'
        labels: style: color: '#E0E0E3'
        lineColor: '#707073'
        minorGridLineColor: '#505053'
        tickColor: '#707073'
        title: style: color: '#A0A0A3'
      yAxis:
        gridLineColor: '#707073'
        labels: style: color: '#E0E0E3'
        lineColor: '#707073'
        minorGridLineColor: '#505053'
        tickColor: '#707073'
        tickWidth: 1
        title: style: color: '#A0A0A3'
      tooltip:
        backgroundColor: 'rgba(0, 0, 0, 0.85)'
        style: color: '#F0F0F0'
      plotOptions:
        series:
          dataLabels: color: '#B0B0B3'
          marker: lineColor: '#333'
        boxplot: fillColor: '#505053'
        candlestick: lineColor: 'white'
        errorbar: color: 'white'
      legend:
        itemStyle: color: '#E0E0E3'
        itemHoverStyle: color: '#FFF'
        itemHiddenStyle: color: '#606063'
      credits: style: color: '#666'
      labels: style: color: '#707073'
      drilldown:
        activeAxisLabelStyle: color: '#F0F0F3'
        activeDataLabelStyle: color: '#F0F0F3'
      navigation: buttonOptions:
        symbolStroke: '#DDDDDD'
        theme: fill: '#505053'
      rangeSelector:
        buttonTheme:
          fill: '#505053'
          stroke: '#000000'
          style: color: '#CCC'
          states:
            hover:
              fill: '#707073'
              stroke: '#000000'
              style: color: 'white'
            select:
              fill: '#000003'
              stroke: '#000000'
              style: color: 'white'
        inputBoxBorderColor: '#505053'
        inputStyle:
          backgroundColor: '#3Comp33'
          color: 'silver'
        labelStyle: color: 'silver'
      navigator:
        handles:
          backgroundColor: '#666'
          borderColor: '#AAA'
        outlineColor: '#CCC'
        maskFill: 'rgba(255,255,255,0.1)'
        series:
          color: '#7798BF'
          lineColor: '#A6C7ED'
        xAxis: gridLineColor: '#505053'
      scrollbar:
        barBackgroundColor: '#808083'
        barBorderColor: '#808083'
        buttonArrowColor: '#CCC'
        buttonBackgroundColor: '#606063'
        buttonBorderColor: '#606063'
        rifleColor: '#FFF'
        trackBackgroundColor: '#404043'
        trackBorderColor: '#404043'
      legendBackgroundColor: 'rgba(0, 0, 0, 0.5)'
      background2: '#505053'
      dataLabelsColor: '#B0B0B3'
      textColor: '#C0C0C0'
      contrastTextColor: '#F0F0F3'
      maskColor: 'rgba(255,255,255,0.3)'
"<b>% Complete</b><br /><b>* Grey bar indicates tracked competency without meeting the clinical context requirement for entrustability.</b><br/>
<b>For a complete list of competencies that meet this criteria, please refer to pp. 51-52 of the Student Handbook.</b>"

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
    backgroundColor: 'white'
    style: fontFamily: 'sans-serif'
  title: style:
    fontSize: '16px'
    fontWeight: 'bold'
    textTransform: ''
  tooltip:
    borderWidth: 0
    backgroundColor: 'rgba(219,219,216,0.8)'
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
  plotOptions: candlestick: lineColor: '#404048'
  background2: '#F0F0EA'

$(document).ready ->

    return unless gon?

    # Load the fonts
    Highcharts.createElement 'link', {
      href: 'https://fonts.googleapis.com/css?family=Unica+One'
      rel: 'stylesheet'
      type: 'text/css'
    }, null, document.getElementsByTagName('head')[0]

    $(".spreadsheet ").DataTable({"aLengthMenu":[[25,50,100,200,-1],[25,50,100,200,"All"]],
    dom: '<"H"Tfr>t<"F"ip>',
    tableTools: {aButtons: ["copy",
                              {
                                    "sExtends": "collection",
                                    "sPdfOrientation": "landscape",
                                    "sButtonText": 'Save <span class="caret" />',
                                    "aButtons":    [ "csv", "xls" ]
                                }], sSwfPath: window.BASE_URL+"assets/dataTables/extensions/TableTools/swf/copy_csv_xls_pdf.swf" }}  )

    $.extend( true, $.fn.DataTable.TableTools.classes, {
        "container": "btn-group",
        "buttons": {
                    "normal": "btn",
                    "disabled": "btn disabled"
                    },
        "collection": {
                        "container": "DTTT_dropdown dropdown-menu",
                        "buttons": {
                            "normal": "",
                            "disabled": "disabled"
                        }
                      }
        } );

    $.extend( true, $.fn.DataTable.TableTools.DEFAULTS.oTags, {
        "collection": {
                        "container": "ul",
                        "button": "li",
                        "liner": "a"
                      }
     } );

    $('[title]').each ->
        $(this).tooltip
            placement: if typeof $(this).attr('data-placement') == 'undefined' then 'bottom' else $(this).attr('data-placement')
            trigger: 'hover'
        return

    $('#pk_selector').change ->
      $("[id^=CourseID").empty
      $("[id^=CourseID").remove
      return

    $('a[data-tab-destination]').click ->
        tab = $(this).attr('data-tab-destination')
        tab = tab.split("^")
        temp_rs_data = {}
        if tab[0].includes("-")
          $('#DomainTabs a[href="#' + tab[0] + '"]').tab('show')
        else
          $('#MyTabs a[href="#' + tab[0] + '"]').tab('show')

        $('.course_detail #course_name').val(tab[1])
        course_id = tab[1].split("~")
        return unless gon?
        rs_data = if gon.rs_data? then gon.rs_data else ''
        data = $.parseJSON(rs_data)
        found_course = getObjects(data, 'CourseID', course_id[1])
        $('.course_detail').remove
        $('.course_detail').html ''
        table = $('.course_detail').append('<table></table>')
        exclude_headers = "MedhubID, StudentEmail, CoachEmail, CoachName, CourseID"
        content = ""
        col = ""
        found_FOM = false
        j = 0
        while j < found_course.length
          obj = found_course[j]
          for key of obj
            attrValue = obj[key]
            if attrValue != null and attrValue.includes("FoM")
              found_FOM = true
              console.log ("found FoM course!")
              break
          j++

        i = 0
        while i < found_course.length
          obj = found_course[i]
          for key of obj
            attrName = key
            attrValue = obj[key]
            if attrValue != null
              if not exclude_headers.includes(attrName)
                col = "<td>" + attrName + "</td>"
                temp_com = attrValue.split("^")
                if temp_com[1] != undefined
                  if temp_com[1] == "Comments: None"
                    if found_FOM
                      comp_fom = temp_com[0].split("~")
                      if comp_fom[1] != undefined
                          col = col + "<td align='left'>" + comp_fom[1] + "</td>"
                      else
                        col = col + '<td align="left">' + "Level: " + comp_fom[0] + "</td>"
                    else
                      col = col + '<td align="left">' + "Level: " + temp_com[0] + "</td>"
                  else
                    col = col + "<td align='left'>" + "Level: " + temp_com[0] + "<br /><br /><font color='blue'>" + temp_com[1] + "</font></td>"
                else
                  col = col + "<td align='left'>" + temp_com[0] + "</td>"
                content = "<tr>" + col + "</tr>"
                table.append(content)
          i++

    @series_data = if gon.series_data? then gon.series_data else ''
    @series_name = if gon.series_name? then gon.series_name else ''

    @series_data_unfiltered = if gon.series_data_unfiltered? then gon.series_data_unfiltered else ''
    overall_epa_mean = @series_data_unfiltered[0]

    if JSON.stringify(@series_data) == JSON.stringify(@series_data_unfiltered)
      #series_data = []
      window.render_to = "epa-container-dark"
      graph_title = "Average EPAs (Class)"
      graph_type = "column"
      series_data_name_1 = "Class Mean"
      series_data_name_2 = "No Student Data"
      series_data_1 = @series_data_unfiltered
      series_data_2 = @series_data
      show_legend_1 = true
      show_legend_2 = false

      window.series_option = [{
        type: 'column'
        name: series_data_name_1
        colorByPoint: true
        data: series_data_1
        showInLegend: show_legend_1
        legend: {
          itemStyle: {
                      width:'200px',
                      textOverflow: 'ellipsis',
                      overflow: 'hidden',
                      font: '12px Helvetica'
                     }
        }
      }]
    else
      window.render_to = "epa-container-dark"
      graph_title = "% Complete - " + @series_name
      series_data_name_1 = @series_name
      series_data_name_2 = "Class Mean"
      series_data_1 = @series_data
      series_data_2 = @series_data_unfiltered
      graph_type = "column"
      show_legend_1 = true
      show_legend_2 = true

      window.series_option = [{
        type: 'column'
        name: series_data_name_1
        colorByPoint: true
        data: series_data_1
        showInLegend: show_legend_1
        legend: {
          itemStyle: {
                      width:'200px',
                      textOverflow: 'ellipsis',
                      overflow: 'hidden',
                      font: '12px Helvetica'
                    }
        }
      },{
        type: 'scatter'
        color: 'lime'
        marker: { symbol: 'diamond'
        }
        name: series_data_name_2
        colorByPoint: false
        data: series_data_2
        showInLegend: show_legend_2
        legend: {
          itemStyle: {
                      width:'200px',
                      textOverflow: 'ellipsis',
                      overflow: 'hidden',
                      font: '12px Helvetica'
                    }
        }
       }]

    #Highcharts.setOptions(Highcharts.theme_dark)
    #Save the HighChart Default Theme
    HCDefaults = $.extend(true, {}, Highcharts.getOptions(), {})
    if @series_data != ""
      window.chart = Highcharts.chart($.extend(true, null, theme_dark, {
        chart:
          renderTo: window.render_to
          polar: true
        title: text: graph_title
        subtitle: text: ''
        xAxis: categories: ['Overall EPA', 'EPA1', 'EPA2', 'EPA3', 'EPA4', 'EPA5', 'EPA6', 'EPA7', 'EPA8', 'EPA9', 'EPA10', 'EPA11', 'EPA12', 'EPA13']
        series: window.series_option
        yAxis: {
            min: 0,
            max: 100,
            endOnTick:false,
            tickInterval:25
          }
        }))

    $('#plain1').click ->
        chart2.update
          chart:
            inverted: false
            polar: false
          subtitle:
            text: "<b>% Complete</b><br /><b>* Grey bar indicates tracked competency without meeting the clinical context requirement for entrustability.</b><br/>
<b>For a complete list of competencies that meet this criteria, please refer to pp. 51-52 of the Student Handbook.</b>"
        return

    $('#inverted1').click ->
        chart2.update
          chart:
            inverted: true
            polar: false
          subtitle:
            text: "<b>% Complete</b><br /><b>* Grey bar indicates tracked competency without meeting the clinical context requirement for entrustability.</b><br/>
<b>For a complete list of competencies that meet this criteria, please refer to pp. 51-52 of the Student Handbook.</b>"
        return

    $('#plain').click ->
        chart.update
          chart:
            inverted: false
            polar: false
          subtitle:
            text: 'Plain'
        return

    $('#inverted').click ->
        chart.update
          chart:
            inverted: true
            polar: false
          subtitle:
            text: 'Inverted'
        return

    $('#polar').click ->
        chart.update
          chart:
            inverted: false
            polar: true
          subtitle:
            text: 'Polar'
        return

    $("[id^=Domain]").draggable handle: '.modal-header'
    $("[id^=EPA]").draggable handle: '.modal-header'
    $("[id^=CourseID]").draggable handle: '.modal-header'

    $('#ShowAllComp').click ->
        return unless gon?
        @all_comp_codes = if gon.all_comp_codes? then gon.all_comp_codes else ''
        @series_data_2 = if gon.series_data_comp_2? then gon.series_data_comp_2 else ''
        @series_data_2_nc = if gon.series_data_comp_2_nc? then gon.series_data_comp_2_nc else ''
        @comp_class_mean = if gon.comp_class_mean? then gon.comp_class_mean else ''
        @series_name = if gon.series_name? then gon.series_name else ''
        @xAxis_category = @all_comp_codes
        @code = 'all-comp'
        @graph_target = "data-visualization-" + "all-comp"
        comp_graph = create_graph(@graph_target, @xAxis_category, @series_data_2, @series_data_2_nc, @comp_class_mean, @code, @series_name)
        first_display = 1

    $('#update-theme').click ->
        button_val = $(this).html()
        if button_val == 'Dark-Theme'
          $("#update-theme").text('Printer-Friendly')
          window.chart = Highcharts.chart($.extend(true, null, theme_dark, {
            chart:
              renderTo: window.render_to
              polar: true
            title: text: graph_title
            subtitle: text: ''
            xAxis: categories: ['Overall EPA', 'EPA1', 'EPA2', 'EPA3', 'EPA4', 'EPA5', 'EPA6', 'EPA7', 'EPA8', 'EPA9', 'EPA10', 'EPA11', 'EPA12', 'EPA13']
            series: window.series_option
            yAxis: {
                min: 0,
                max: 100,
                endOnTick: false,
                tickInterval: 25
              }
            }))
        else
          $("#update-theme").text('Dark-Theme')
          window.chart = Highcharts.chart($.extend(true, null, HCDefaults, {
            chart:
              renderTo: window.render_to
              polar: true
            title: text: graph_title
            subtitle: text: ''
            xAxis: categories: ['Overall EPA', 'EPA1', 'EPA2', 'EPA3', 'EPA4', 'EPA5', 'EPA6', 'EPA7', 'EPA8', 'EPA9', 'EPA10', 'EPA11', 'EPA12', 'EPA13']
            series: window.series_option
            yAxis: {
                min: 0,
                max: 100,
                endOnTick: false,
                tickInterval: 25
              }
            }))

        return

    Domain = ["ICS", "MK", "PBLI", "PCP", "PPPD", "SBPIC"]

    $('a[data-toggle="tab"]').on 'shown.bs.tab', (e) ->
      # get current tab
      currentTab = $(e.target).text()
      @comp_code = currentTab.split("-")
      console.log ("currentTab:" + currentTab)
      if Domain.includes(@comp_code[0])
        # Competency graph
        return unless gon?

        @comp_domain = if gon.comp_domain? then gon.comp_domain else ''
        @series_data_2 = if gon.series_data_comp_2? then gon.series_data_comp_2 else ''
        @series_data_2_nc = if gon.series_data_comp_2_nc? then gon.series_data_comp_2_nc else ''
        @comp_class_mean = if gon.comp_class_mean? then gon.comp_class_mean else ''
        @series_name = if gon.series_name? then gon.series_name else ''
        @xAxis_category = @comp_domain[@comp_code[0]]
        @graph_target = "data-visualization-" + @comp_code[0]
        comp_ind_graph = create_graph(@graph_target, @xAxis_category, @series_data_2, @series_data_2_nc, @comp_class_mean, @comp_code[0], @series_name)
      else if currentTab.includes("Competency-Graph")
        return unless gon?

        @all_comp_codes = if gon.all_comp_codes? then gon.all_comp_codes else ''
        @series_data_2 = if gon.series_data_comp_2? then gon.series_data_comp_2 else ''
        @series_data_2_nc = if gon.series_data_comp_2_nc? then gon.series_data_comp_2_nc else ''
        @comp_class_mean = if gon.comp_class_mean? then gon.comp_class_mean else ''
        @series_name = if gon.series_name? then gon.series_name else ''
        @xAxis_category = @all_comp_codes
        @code = 'all-comp'
        @graph_target = "data-visualization-" + "all-comp"
        comp_graph = create_graph(@graph_target, @xAxis_category, @series_data_2, @series_data_2_nc, @comp_class_mean, @code, @series_name)
      else if currentTab.includes("FoM Block")
        return unless gon?

        @all_comp_codes = if gon.all_comp_codes? then gon.all_comp_codes else ''
        @series_data_2 = if gon.allblocks? then gon.allblocks else ''
        @comp_class_mean = if gon.allblocks_class_mean? then gon.allblocks_class_mean else ''
        @series_data_2_nc = ""
        @series_name = if gon.series_name? then gon.series_name else ''
        @xAxis_category = ["Comp1", "Comp2", "Comp3", "Comp4", "Comp5"]
        @code = 'allblocks'
        @graph_target = ""
        comp_graph = create_graph(@graph_target, @xAxis_category, @series_data_2, @series_data_2_nc, @comp_class_mean, @code, @series_name)

      else if currentTab.includes("Preceptorship")
        return unless gon?

        @series_data_2 = if gon.preceptorship? then gon.preceptorship else ''
        @precept_class_mean = if gon.preceptorship_class_mean? then gon.preceptorship_class_mean else ''
        @series_data_2_nc = ""
        @series_name = if gon.series_name? then gon.series_name else ''
        @xAxis_category = ""
        @code = 'preceptorship'
        @graph_target = ""
        precept_graph = create_graph(@graph_target, @xAxis_category, @series_data_2, @series_data_2_nc, @precept_class_mean, @code, @series_name)
      else if not currentTab.includes("EPA-Graph")
        return unless gon?

        @all_comp_codes = if gon.all_comp_codes? then gon.all_comp_codes else ''
        @series_data_2 = if gon.series_data_comp_2? then gon.series_data_comp_2 else ''
        @series_data_2_nc = if gon.series_data_comp_2_nc? then gon.series_data_comp_2_nc else ''
        @comp_class_mean = if gon.comp_class_mean? then gon.comp_class_mean else ''
        @series_name = if gon.series_name? then gon.series_name else ''
        @xAxis_category = @all_comp_codes
        @code = "student"  #'all-comp'
        @graph_target = "data-visualization-" + 'student'  #"all-comp"
        if @all_comp_codes != ""
          student_comp_graph = create_graph(@graph_target, @xAxis_category, @series_data_2, @series_data_2_nc, @comp_class_mean, @code, @series_name)
