$(document).ready ->   

        
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

    $('a[data-tab-destination]').click ->
        tab = $(this).attr('data-tab-destination')
        console.log("tab: " + tab)
        $('#MyTabs a[href="#' + tab + '"]').tab('show')
        return


    $ ->
      #alert("gon " + gon.series_data)
      series_data = if gon.series_data? then gon.series_data else ''
      chart = Highcharts.chart(
        chart:
          renderTo: 'epa-container'
          polar: true
        title: text: '% of Completion'
        subtitle: text: ''
        xAxis: categories: ['EPA1', 'EPA2', 'EPA3', 'EPA4', 'EPA5', 'EPA6', 'EPA7', 'EPA8', 'EPA9', 'EPA10', 'EPA11', 'EPA12', 'EPA13']
        series: [ {
          type: 'column'
          name: 'Student'
          colorByPoint: true
          data: series_data
          showInLegend: true
          legend: {
            itemStyle: {
                        width:'200px',
                        textOverflow: 'ellipsis',
                        overflow: 'hidden',
                        font: '12px Helvetica'
                      }
          }
        },{
          type: 'line'
          name: 'Class Mean'
          colorByPoint: false
          data: [25, 35, 28, 32, 15, 20, 35, 18, 25, 28, 32, 15, 18]
          showInLegend: true
          legend: {
            itemStyle: {
                        width:'200px',
                        textOverflow: 'ellipsis',
                        overflow: 'hidden',
                        font: '12px Helvetica'
                      }
          }
         }])
        
      $('#plain').click ->
          chart.update
            chart:
              inverted: false
              polar: false
              subtitle: text: 'Plain'
          return
      $('#inverted').click ->
          chart.update
            chart:
              inverted: true
              polar: false
              subtitle: text: 'Inverted'
          return
      $('#polar').click ->
          chart.update
            chart:
              inverted: false
              polar: true
              subtitle: text: 'Polar'
          return
    return

  

'use strict'

### global document ###

# Load the fonts
Highcharts.createElement 'link', {
  href: 'https://fonts.googleapis.com/css?family=Unica+One'
  rel: 'stylesheet'
  type: 'text/css'
}, null, document.getElementsByTagName('head')[0]
Highcharts.theme =
  colors: [
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
    style: fontFamily: '\'Unica One\', sans-serif'
    plotBorderColor: '#606063'
  title: style:
    color: '#E0E0E3'
    textTransform: 'uppercase'
    fontSize: '20px'
  subtitle: style:
    color: '#E0E0E3'
    textTransform: 'uppercase'
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
      backgroundColor: '#333'
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
# Apply the theme
Highcharts.setOptions Highcharts.theme 
