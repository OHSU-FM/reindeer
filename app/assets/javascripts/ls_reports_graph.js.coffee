##
# TODO:
#   - Ditch all redundant redundant data in view
#   - Print out "No graph available" for not implemented and missing/empty

window.LsReport = {}
window.LsReport.Graph = {}

Array::max=->
    Math.max.apply(null, this)

Array::min=->
    Math.min.apply(null, this)

@chart_args = (graph) ->

    data = graph.data()

    full_data = graph.full_data()

    max_item = data.max()
    if (max_item < 10 )
            max_item = 10
            max_tick = null 
    else if (max_item > 10 && max_item < 50)
            max_item = 50
            max_tick = null
        else if (max_item > 50 && max_item <= 100) 
                max_item = 100
                max_tick = 10
            else
                max_item = 100 
                max_tick = 10 


    category_labels = graph.category_labels()
    chart_type = graph.chart_type

    switch chart_type
        when 'spider' 
            chart_type = 'line'
            var_pointPlacement = 'on'
            polar = true
            yTitleText = ''
            xTitleText = ''
            three_d_enabled  = false
        when 'scatter'
            chart_type = 'scatter'
            var_pointPlacement = 'off'
            polar = false
            yTitleText = graph.yTitleText 
            xTitleText = graph.xTitleText
            three_d_enabled = false

        when 'pie'
            full_data = ''

        else
            var_pointPlacement = 'off'
            yTitleText = graph.yTitleText 
            xTitleText = graph.xTitleText
            three_d_enabled = false #true

        

    return {
        chart: {
            type: chart_type,
            renderTo: graph.target,
            polar: polar,  # for spider chart,
            options3d: {
                enabled: three_d_enabled,
                alpha: 15,
                beta: 6,
                depth: 40,
                viewDistance: 25
            },
            #backgroundColor:'rgba(255, 255, 255, 0.4)'
            backgroundColor: null,
            height: 380,
            width:490
        },

        plotOptions: {
            column: {
                depth: 25
            },
            series: {
                borderWidth: 2
            }
            pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    depth: 35,
                    dataLabels: {
                        enabled: true,
                        format: '{point.name}'
                    },
                    showInLegend: false 
                 }
        },

        pane: {
                 size: '100%'
              },

        title: {text:graph.title},

        yAxis: {
            min: 0, max: max_item, lineWidth: 0, tickInterval: max_tick, 
            pointPlacement: var_pointPlacement, 
            lineWidth: 0, 
            gridLineInterpolation: 'polygon',
            gridLineColor: '#555'
            title: {
                text: yTitleText,
                style: {
                    color: '#222'
                }
            },
            labels:{
                style: {
                    color: '#222'
                }
            }
        },
        xAxis: {
            tickInterval: 1, 
            tickmarkPlacement: 'on',
            pointPlacement: 'on',
            lineWidth: 0,
            tickColor: '#555'
            title: {
                text: xTitleText,
                style: {
                    color: '#222'
                }
            },
            labels: { 
                formatter: -> 
                    if (this.value.length > 20)
                        return this.value.substr(0,20) + "...";
                    else
                        return this.value;   
                                               

                style: {
                    color: '#222',
                    font: '12px Helvetica',
                    fontWeight: 'bold',
                    textOverflow: 'ellipsis',
                    overflow: 'hidden'
                },
                enabled: true
            },
            categories: category_labels
        },

        legend: {
                    itemStyle: {
                                  width:'50px',
                                  textOverflow: 'ellipsis',
                                  overflow: 'hidden'
                                }  
                },

        series: [{
                    
                     name: 'Mean ' + graph.unfiltered_series_name,
                     color: '#4497e3',
                     #pointPlacement: var_pointPlacement,
                     data: full_data  # q68
                  }, {
                     
                     name: graph.filtered_series_name,      #'Judith Bowen',
                     visible: graph.filtered_series_name,
                     showInLegend: graph.filtered_series_name,
                     pointPlacement: var_pointPlacement,
                     color: 'lime',             
                     data: data
                  }]
    };

class LsGraphBase
    constructor: (target, graph_type,  qstat, full_qstat, filtered_series_name, unfiltered_series_name, filters_equal, title) ->
        @qstat = qstat
        @full_qstat = full_qstat
        @$target = target
        @$container = @$target.parent()
        @$options = @$container.find('.role-chart-options')
        @event_handlers()
        if graph_type?
            @chart_type = graph_type
        else
            @chart_type = 'column' 

        @filters_equal = filters_equal
        @yTitleText = undefined
        @xTitleText = undefined

        @filtered_series_name = filtered_series_name   # Filtered data series name
        if unfiltered_series_name 
            @unfiltered_series_name =  unfiltered_series_name  # unfiltered data series name
        else
            @unfiltered_series_name = '(All)'

        @title = if title? then title else ''

        return
    
    event_handlers: -> 
        klass = @
        @$container.on 'change', '.role-chart-options', (event) =>
            @chart_type = klass.$options.val()
            $('.new_question_widget').append('<input type="hidden" name="question_widget[graph_type]" value=' + @chart_type + '>')
            klass.draw() 
    
    chart_args: ->
        chart_args(@)

    draw: ->
        # Draw chart
        highchart = $(@$target).highcharts(@chart_args());
        highchart = $(highchart).highcharts()
    
        # Hide second series if they are equal
        if @filters_equal == true 
            highchart.series[1].hide()
        # Add hook for dashboard

        $(@$target).find('.highcharts-container').addClass('widget-resize-hook');

        return

class LsGraphCategories extends LsGraphBase

    constructor: -> 
        super 
        @yTitleText = '% Responses'
        @xTitleText = 'Answer Options'
     
    data: ->
        qstat = @qstat
        result = (Number(cat.percent.toFixed(2)) for cat in qstat.categorical_stats)
        return result


    chart_args: ->

        ca = chart_args(@)
        if @chart_type == 'pie'
            ca.chart.type = 'pie'
            ca.chart.options3d.alpha = 45
            ca.chart.options3d.beta = 0
            ca.chart.options3d.enabled = true
            ca.series[0].type = 'pie'
            ca.series[0].data = @category_data()
            ca.series[1] = '' #null #@full_data()
        else
            ca.chart.options3d.enabled = false
            ca.series[0].type = @chart_type #'pie'
            ca.series[0].data = @full_data()
            ca.series[1].data = @data()
            ca.series[0].color = '#4497e3'
            ca.series[1].color = 'lime'
            ca.series[1].name  = @filtered_series_name
            if @chart_type == 'spider'
                ca.chart.type = 'line'
                ca.chart.polar = true
                ca.yAxis.pointPlacement = 'on'
                ca.xAxis.pointPlacement = 'on'
                ca.xAxis.title.text = ''
                ca.yAxis.title.text = ''
                ca.yAxis.gridLineInterpolation = 'polygon'
                ca.yAxis.min = 0 
                ca.yAxis.max = null 
                ca.yAxis.tickInterval = null 
                ca.series[0].type = ''
            else
                ca.chart.poloar = false
                ca.yAxis.pointPlacement = 'off'


        return ca

    full_data: ->
        qstat = @full_qstat
        return (Number(cat.percent.toFixed(2)) for cat in qstat.categorical_stats)
   
    category_labels: ->
        qstat = @qstat
        return (cat.answer for cat in qstat.categorical_stats)
    
    category_data: ->
        qstat = @qstat
        return ([cat.answer, cat.percent] for cat in qstat.categorical_stats when cat.frequency != 0)

class LsGraphDescriptivesMultNumeric extends LsGraphBase

    constructor: ->
        super 
        @yTitleText = 'Scores'
        @xTitleText = 'Categories'


    data: ->
        qstat = @qstat

        #result = (Number(sub.descriptive_stats.mean.toFixed(2)) for sub in qstat.sub_stats)
        #return result
        result = []
        for sub in qstat.sub_stats
            rounded_float = sub.descriptive_stats.mean 
            if !rounded_float
                rounded_float = 0

            if rounded_float < 50
                result.push rounded_float
            else if rounded_float < 70.00
                    result.push {y: rounded_float, color:'#FFA500'} 
                 else
                    result.push rounded_float
        return result

    full_data: ->
        qstat = @full_qstat
        #result = (Number(sub.descriptive_stats.mean.toFixed(2)) for sub in qstat.sub_stats)
        #return result
        result = []
        for sub in qstat.sub_stats
            rounded_float = sub.descriptive_stats.mean
            if !rounded_float?
                rounded_float = 0
            else
                rounded_float = Number(rounded_float.toFixed(2))
    
            if rounded_float < 50
                result.push rounded_float
            else if rounded_float < 70.00
                    result.push {y: rounded_float, borderColor:'#FFA500'} 
                else
                    result.push rounded_float

        return result
   
    category_labels: ->
        qstat = @qstat
        return (sub_stat.q_text for sub_stat in qstat.sub_stats)

class LsGraphDescriptivesNumeric extends LsGraphBase

    constructor: ->
        super 
        @yTitleText = 'Scores'
        @xTitleText = 'Categories'

    data: ->
        qstat = @qstat
        result = []
        rounded_float = Number(qstat.descriptive_stats.mean.toFixed(2))
        if rounded_float < 70.00   
            result.push {y: rounded_float, color:'#FFA500'}
        else
            result.push rounded_float 
        return result

    full_data: ->
        qstat = @full_qstat
        result = []
        result.push Number(qstat.descriptive_stats.mean.toFixed(2))
        return result
   
    category_labels: ->
        qstat = @qstat
        result = []
        result.push qstat.q_text
        return result 

class LsGraphArrFlex
    #
    # Used only on ls_reports/graph
    #
    constructor: (target, graph_type, qstat, full_qstat, series_name, unfiltered_series_name, filters_equal, title) ->
        @qstat = qstat
        @full_qstat = full_qstat
        @charts = []
        charts = @charts
        $(qstat.sub_stats).each (idy, cur_qstat) ->
            cur_full_qstat = full_qstat.sub_stats[idy]
            # Assume we can find the target
            cur_target = target.find('.chart-visualization-'+ cur_qstat.qid)
            chart = new LsGraphArrFlexChild(cur_target, graph_type, cur_qstat, cur_full_qstat, series_name, unfiltered_series_name, filters_equal, title)
            charts.push chart

    draw: ->
        $(@charts).each (idx, chart) ->
            chart.draw()

class LsGraphArrFlexChild extends LsGraphCategories;

#   Used for Dashboard
#

window.LsReport = {}
window.LsReport.Graph = {}
window.LsReport.Graph.load = (target, graph_type, qstat, full_qstat, series_name, unfiltered_series_name, filters_equal, title) ->
    chart = undefined
    return unless qstat?
    switch qstat.qtype
        when "arr_flex"
            # one graph for each sub question
            chart = new LsGraphArrFlex(target, graph_type, qstat, full_qstat, series_name, unfiltered_series_name, filters_equal, title)
        when 'arr_flex_child'
            chart = new LsGraphArrFlexChild(target, graph_type, qstat, full_qstat, series_name, unfiltered_series_name, filters_equal, title)
        when 'mult_numeric'
            chart = new LsGraphDescriptivesMultNumeric(target, graph_type, qstat, full_qstat, series_name, unfiltered_series_name, filters_equal, title)
        when 'numeric'
            # Only graph if the data is there
            if !$.isEmptyObject(qstat.descriptive_stats)
                chart = new LsGraphDescriptivesNumeric(target, graph_type, qstat, full_qstat, series_name, unfiltered_series_name, filters_equal, title)
        when 'mult', 'list_radio', 'yes_no', 'gender', 'dual_arry'
            chart = new LsGraphCategories(target, graph_type, qstat, full_qstat, series_name, unfiltered_series_name, filters_equal, title)

        else
            #console.log 'Unimplemented graph type: ' + qstat.qtype
        
    if chart?
        chart.draw()
    return chart
$(document).ready ->
    return if $('body').attr('id') != 'ls_reports_graph'
    window.scroll_spy_init() 
    
    window.charts = []

    
    return unless gon?
    return unless gon.qstats?
    
    series_name = if gon.series_name? then gon.series_name else ''
    unfiltered_series_name = if gon.unfiltered_series_name? then gon.unfiltered_series_name else ''
    filters_equal = if gon.filters_equal? then gon.filters_equal else false

    $(gon.qstats).each (idx, qstat) ->
        full_qstat = gon.full_qstats[idx]
        $target = $('.chart-visualization-' + full_qstat.qid)
        chart = window.LsReport.Graph.load($target, @chart_type, qstat, full_qstat, series_name, unfiltered_series_name, filters_equal)
        window.charts.push chart 
    $('body').scrollspy('refresh');

