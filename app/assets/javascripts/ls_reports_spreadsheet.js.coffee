
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


get_series_data = (series_data_hash, in_code) ->
  series_data = []
  for k of series_data_hash
    #alert("k: " + k + " in_code: " + in_code)
    if series_data_hash.hasOwnProperty(k)
      if k.includes(in_code)
        series_data.push series_data_hash[k]
  series_data



create_graph = (graph_target, xAxis_category, series_data_hash, comp_class_mean_hash, in_code) ->
          series_data_1 = get_series_data(series_data_hash, in_code)
          series_data_2 = get_series_data(comp_class_mean_hash, in_code)

          #alert("series_data_2: " + series_data_2)
          render_to_2 = graph_target
          graph_title = "Domain: " + in_code
          graph_sub_title = "% Complete"
          series_data_name_2= "Class Mean"
          series_data_name_1 = in_code
          series_data_1 = series_data_1
          series_data_2 = series_data_2

          #series_data_2 = "Null"
          graph_type = "column"
          show_legend_1 = true
          show_legend_2 = true
          xAxis_category = xAxis_category

          series_option2 = [{
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
                type: 'column'
                color: 'blue'
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


          window.chart2 = Highcharts.chart($.extend(true, null, theme_light, {
            chart: renderTo: render_to_2
            title: text: graph_title
            subtitle: text: graph_sub_title
            xAxis: categories: xAxis_category
            series: series_option2
            yAxis: {
                min: 0,
                max: 100,
                endOnTick:false,
                tickInterval:25
              }
            }))



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
    backgroundColor: null
    style: fontFamily: 'sans-serif'
  title: style:
    fontSize: '16px'
    fontWeight: 'bold'
    textTransform: 'uppercase'
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
    # hover all the tab, it will display the tab data
    #$('#MyTabs a').hover (e) ->
    #  e.preventDefault()
    #  $(this).tab 'show'
    #  return

    # $('#MainTabs a').hover (e) ->
    #  e.preventDefault()
    #  $(this).tab 'show'
    #  return

    #$('#MyCompetencyTabs a').hover (e) ->
    #  e.preventDefault()
    #  $(this).tab 'show'
    #  return

    $('#pk_selector').change ->
      $("[id^=CourseID").empty
      $("[id^=CourseID").remove
      return

    $('a[data-tab-destination]').click ->

        tab = $(this).attr('data-tab-destination')
        tab = tab.split("^")
        temp_rs_data = {}
        console.log("tab0" + tab[0])
        console.log("tab1 " + tab[1])
        if tab[0].includes("-")
          $('#DomainTabs a[href="#' + tab[0] + '"]').tab('show')
        else
          $('#MyTabs a[href="#' + tab[0] + '"]').tab('show')
        $('.course_detail #course_name').val(tab[1])
        course_id = tab[1].split("~")
        rs_data = if gon.rs_data? then gon.rs_data else ''

        data = $.parseJSON(rs_data)
        found_course = getObjects(data, 'CourseID', course_id[1])
        #console.log(JSON.stringify(found_course, null, "    "))
        #onsole.log("found_course: " + found_course[0].CourseID)

        $('.course_detail').remove
        $('.course_detail').html ''
        #Crate table html tag

        #table = $('<table id=DynamicTable ></table>').appendTo('.course_detail')
        table = $('.course_detail').append('<table></table>')
        console.log("length: " + found_course.length)
        exclude_headers = "MedhubID, StudentEmail, CoachEmail, CoachName, CourseID"
        content = ""
        col = ""
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
                         col = col + '<td align="left">' + "Level: " + temp_com[0] + "</td>"
                      else
                        col = col + "<td align='left'>" + "Level: " + temp_com[0] + "<br /><br /><font color='blue'>" + temp_com[1] + "</font></td>"
                else
                  col = col + "<td align='left'>" + temp_com[0] + "</td>"
                #console.log ("col: " + col)
                content = "<tr>" + col + "</tr>"
                #console.log("content:" + content)
                table.append(content)
          i++

    return unless gon?
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
      graph_type = "line"
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
        type: graph_type
        color: 'lime' #FFFFFF'
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
        chart.updateRing WiFi-Enabled Video Doorbell
          chart:
            inverted: false
            polar: true
          subtitle:
            text: 'Polar'
        return

    $('#update-theme').click ->
        button_val = $(this).html()
        #alert("button_val:" + button_val)
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
                endOnTick:false,
                tickInterval:25
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
                endOnTick:false,
                tickInterval:25
              }
            }))

        return

    Domain = []
    Domain = ["ICS", "MK", "PBLI", "PCP", "PPPD", "SBPIC"]

    $('a[data-toggle="tab"]').on 'shown.bs.tab', (e) ->
      # get current tab
      currentTab = $(e.target).text()
      #LastTab = $(e.relatedTarget).text()
      @comp_code = currentTab.split("-")
      if Domain.includes(@comp_code[0])   #currentTab.includes("PBLI")
          #alert("currentTab: " + currentTab)
          @comp_domain = if gon.comp_domain? then gon.comp_domain else ''
          @series_data_2 = if gon.series_data_comp_2? then gon.series_data_comp_2 else ''
          @comp_class_mean = if gon.comp_class_mean? then gon.comp_class_mean else ''
          @xAxis_category = @comp_domain[@comp_code[0]]
          @graph_target = "data-visualization-" + @comp_code[0]
          series_option2 = create_graph(@graph_target, @xAxis_category, @series_data_2, @comp_class_mean, @comp_code[0])

    return



    'use strict'

    ### global document ###




