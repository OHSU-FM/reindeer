//  require pivottable/jquery-1.8.3.min.js
//  require pivottable/jquery-ui-1.9.2.custom.min.js
//= require pivottable/pivot.js
//= require pivottable/gchart_renderers.js
//= require pivottable/d3_renderers.js

// import jQuery
$ = jQuery;

function load_has_many(klass, opts){
    var result = [];
    $(opts).each(function(){
        var var_new = new klass($(this)[0]);
        result.push(var_new);
    })
    return result;
}
ChartSeries = function(opts){
    var defaults = {};
    var klass = $.extend({}, defaults, opts);
    return klass;
}
Questions = function(opts){
    var defaults = {};
    var klass = $.extend({}, defaults, opts);
    return klass;
}
ChartModel = function(opts){
    var defaults = {};
    var klass = $.extend({}, defaults, opts);
    var chart_series = [];
    klass.chart_series = load_has_many(ChartSeries, klass.chart_series);
    klass.questions = load_has_many(Questions, klass.questions);
    klass.attr_convert = function(arr){
        var result = [];
        for (var idx = 0; idx < arr.length; ++idx) {
            result.push(klass.attr_names[arr[idx]]);
        }
        return result;
    }
    klass.col_names = function(){
        return klass.attr_convert(klass.cols);
    }
    klass.row_names = function(){
        return klass.attr_convert(klass.rows);
    }
    // Produce the chart dataset with the values converted to labels
    klass.converted_dataset = function(){
        console.log('checking dataset');

        var dataset = klass.dataset;        // Shorthand alias for our dataset
        var result = $.extend(true, [], dataset);
        var questions = klass.questions;    // Shorthand alias for our questions
        var attr_names = [];                // Store the name of each attribute we've processed

        // Bail out if no dataset present
        if(dataset.length == 0){throw new EmptyDatasetError('Empty Dataset')}

        // For each question
        for (var q_idx = 0; q_idx < questions.length; ++q_idx) {

            // Make sure this is a question with an attr_name that is new
            var question = questions[q_idx];
            var options = $.parseJSON(question.options_hash);

            // Find index of this question in the dataset
            var col_idx = dataset[0].indexOf(question.attribute_name);
            if(col_idx==-1){throw new MissingQuestionError('Unknown Question: '+question.attribute_name);}

            // Change header for this column
            result[0][col_idx] = question.short_name;

            //skip header row, d_idx = 1
            // For every row of data
            for (var d_idx = 1; d_idx < dataset.length; ++d_idx) {
                var val = String(result[d_idx][q_idx]);
                // For every option in dictionary
                for(var opt_idx = 0; opt_idx < options.length; ++opt_idx){
                    // change number to dictionary definition
                    var option = options[opt_idx];
                    if (val == String(option.value) ){
                        result[d_idx][col_idx] = option.description;
                        break;
                    }
                    // Remove trailing \d.00 for values
                }
            }
        };

        // return result
        return result;
    }

    return klass;
}

Chart = function(container, opts){
    /*
        Class initialization
    */

    // Class instance variables
    var defaults = {
        show_ui:    true,           // Show ui controls for chart?
        width:      200,            // Chart width
        height:     200,            // Chart Height
        auto_add_questions: true,   // Automatically add questions if not present in cols/rows
        _dataset: null,             // Internal variable for storing dataset
        init_complete: false
    };

    // Define opts if they were not included
    if(typeof(opts)=='undefined'){opts={};}

    // Merge class variables with any options that were passed in
    var klass = $.extend({}, defaults, opts);
    klass.container = $(container);
    klass.chart_model = new ChartModel(klass.chart_model);

    /*
        Class methods
    */

    // Register event handlers for ChartBuilder Object
    klass.init_event_handlers = function(opts){

        // A select field has changed, submit and update the form
        klass.container.on('change','.chart-series-container select', function(event){
            klass.refresh();
        });

        // Update form based on current contents of the chart
        klass.container.on('submit', 'form.chart-container', function(event){
            klass.dump_visualization_to_form_data();
        });

        /* We removed a column */
        klass.container.on('cocoon:after-insert', function(e, ItemInserted){
            console.log('cocoon after insert');
            if(klass.form().find('.chart-series').length >= klass.chart_model.max_series_count){
                klass.form().addClass('disable_add_fields');
            }else{
                klass.form().addClass('dirty');
            }
        });

        klass.container.on('cocoon:before-insert', function(e, ItemToInsert, result){
            console.log('cocoon before insert');
            if(klass.form().find('.chart-series').length >= klass.chart_model.max_series_count){
                klass.form().addClass('disable_add_fields');
                result.val = false;
            }else{
                klass.form().addClass('dirty');
            }
        });

        klass.container.on('cocoon:after-remove', function(e, removedItem){
            console.log('cocoon and after remove');
            if(klass.form().find('.chart-series').length < klass.chart_model.max_series_count){
                klass.form().removeClass('disable_add_fields');
            }
            klass.form().addClass('dirty');
        });

        // The chart title changed
        klass.container.on('change','#chart_title', function(event){
            klass.container.find('#chart_title_label').text($(this).val());
            klass.form().addClass('dirty');
        });

        // A select field has changed, submit and update the form
        klass.container.on('click','a.submit-chart', function(event){
            klass.save();
        });
        //
        //klass.container.on("sortreceive", '.pvtAxisContainer', function( event, ui ) {
        //    klass.form().addClass('dirty');
        //    klass.dump_visualization_to_form_data();
        //});

        klass.form().on('ajaxSuccess',function(){
            console.log('form ajax success');
        });

    }

    /* Save the form */
    klass.save = function(){
        klass.refresh('POST');
    }

    /* Refresh the form with new data and mark the form as changed/dirty */
    klass.on_visualization_refresh = function(){
        console.log('vis refresh occurred')
        klass.dump_visualization_to_form_data();
        // mark dirty if this is not the first refresh
        if(klass.init_complete==true){
            klass.form().addClass('dirty');
        }else{
            klass.init_complete = true;
        }
    }

    /*
        pull new form data from website based on current form
    */
    klass.refresh = function(method){

        method = method || 'GET';

        // Shorthand aliases
        var container = klass.container;
        var form = klass.form();

        // Get ajax form url
        var show_chart_path = form.find('.show_chart_path').data('show-chart-path');

        // Ajax call to update
        $.ajax({
            url: show_chart_path,
            form: form,             // Pass in form object so we can access in the success callback
            dataType: 'HTML',
            method: method,
            data: $(form).serialize() + '&layout=false',  // Tell rails to render without a full html body
            success: function(xhr){
                console.log('Refresh: success');
                form.replaceWith($(xhr).find('form'));  //
                klass.init_chart();     // Re initialize and replace chart with new one
            },
            error: function(xhr){
                console.log('Refresh: error');
            },
            complete: function(xhr){
                console.log('Refresh: complete');
                if (method == 'GET'){
                    klass.form().addClass('dirty');
                }
            }
        });
    }

    /*
        Update form based on state of chart
    */
    klass.dump_visualization_to_form_data = function(){
        console.log('vis dump occurred')
        // Template string for axis entry
        var template = '<input id="chart_#type#" multiple="multiple" name="chart[#type#][]" type="hidden" value="#value#">';
        var pivot_parser = new PivotParser(klass.form());

        // strNodes to append to form
        var t_cols = $.map( pivot_parser.cols(), function(val, i){
            var col_name = klass.chart_model.attr_names[val];
            return template.replace(/#type#/g,'cols').replace(/#value#/g, col_name);
        });

        var t_rows = $.map( pivot_parser.rows(), function(val, i){
            var row_name = klass.chart_model.attr_names[val];
            return template.replace(/#type#/g,'rows').replace(/#value#/g, row_name);
        });

        //var t_filters = $.map( pivot_parser.filtered_attrs(), function(val, i){
        //    return template.replace(/#type#/g,'entities_filter').replace(/#value#/g, val);
        //});

        // remove old nodes
        var hidden_fields = klass.form().find('.chart-hidden-fields');

        hidden_fields.find('input[name="chart[cols][]"][value!=""]').remove();
        hidden_fields.find('input[name="chart[rows][]"][value!=""]').remove();
        //klass.form().find('input[name^="chart[chart_series_attributes]"]').filter('input[id$=entities_filter]').remove();

        // Add new nodes
        var new_nodes = $.makeArray(t_cols).join()+$.makeArray(t_rows).join();//+$.makeArray(t_filters).join();
        hidden_fields.append( new_nodes );

        /* Update aggregator type and table type */
        klass.form().find('#chart_chart_type').val( pivot_parser.chartType() );
        klass.form().find('#chart_aggregator_type').val( pivot_parser.aggregatorType() );
    }

    /*
        Create a pivot chart with the chart data
    */
    klass.pivot_chart = function(container, width, height){
        var renderers = $.extend($.pivotUtilities.renderers, $.pivotUtilities.gchart_renderers);
        var derivers = $.pivotUtilities.derivers;
        var chart = klass.chart_model;

        if(typeof(chart) == 'undefined'){throw new MissingChartDataError('Missing Chart Element')}
        if(chart.dataset == null ){throw new MissingChartDataError('Missing Data Set')}
        var node = $(container).find('.chart-visualization');
        if(typeof(node) == 'undefined' ){throw new MissingChartDataError('Missing Node')}

        width = width || chart.width || 200;
        height = height || chart.height || 200;

        var opts = {
            renderers: renderers,
            rendererOptions: {chart_width: width, chart_height: height},
            derivedAttributes: {},
            rendererName: chart.chart_type || 'Table',
            cols: klass.chart_model.col_names(),
            rows: klass.chart_model.row_names(),
            onRefresh: klass.on_visualization_refresh, //klass.dump_visualization_to_form_data,
            aggregatorName: chart.aggregator_type || 'Count'
        };

        if (klass.show_ui == true){
            klass.pivot = $(node).pivotUI(chart.converted_dataset(), opts, true);
        }else{
            klass.pivot = $(node).pivot(chart.converted_dataset(), opts, true);
        }
        // Add a resize hook for the chart, used by dashboard
        klass.pivot.find('table').addClass('widget-resize-hook');
    }

    /* Find form node for the chart */
    klass.form = function(){return klass.container.find('form');}

    /*
        Create a new chart and catch missing data errors
    */
    klass.init_chart = function(){

        var chart_model_data = klass.container.find('.chart-data').data('chart');
        klass.chart_model = new ChartModel(chart_model_data);

        try{
            klass.pivot_chart(klass.container, klass.width, klass.height)
        }catch(e){
            if(e.name == 'MissingChartDataError'){
                console.log(e.message);
            }else{
                throw(e);
            }
        }
    }


    /*
        Final Class initialization
    */

    klass.init_event_handlers();
    klass.init_chart();
    return klass;
};

function MissingChartDataError(message){
    this.name = 'MissingChartDataError';
    this.message = (message||"");
}
MissingChartDataError.prototype = new Error();

function MissingDatasetError(message){
    this.name = 'MissingDatasetError';
    this.message = (message||"");
}
MissingDatasetError.prototype = new Error();

function MissingQuestionError(message){
    this.name = 'MissingQuestionError';
    this.message = (message||"");
}
MissingQuestionError.prototype = new Error();


PivotParser = function(container, opts){
    /*
        Class initialization:
        A helper class for getting useful information out of
        the Pivot Table Object.
    */

    // import jQuery
    $ = jQuery;

    // Class instance variables
    var defaults = {
    };

    // Merge class variables with any options that were passed in
    var klass = $.extend({}, defaults, opts);
    klass.container = $(container);

    // List all of the cols in the chart
    klass.cols = function(){
        return klass.rc_extract('.pvtCols li span.pvtAttr');
    }

    // List all of the rows in the chart
    klass.rows = function(){
        return klass.rc_extract('.pvtRows li span.pvtAttr');
    }
    // Helper function to list rows and columns
    klass.rc_extract = function(selector){
        return klass.container.find(selector).clone().children().remove().end().map(function(){
            return $(this).text();
        }).get();
    }

    // Filter the attributes for the chart and return their values
    klass.filtered_attrs = function(){
        return klass.container.find('.pvtFilterBox').map(function(){
            var name = $(this).find('h4').text().replace(/ \(\d+\)/,'');
            var attrs = $(this).find('input:checkbox:not(:checked)').map(function(){
                return $(this).siblings('span').text().replace(/ \(\d+\)$/,'');
            }).get();
            if(attrs.length > 0){
                return {name: name, attrs: attrs }
            }
        }).get();
    }

    // List aggregator type
    klass.aggregatorType = function(){
        return klass.container.find('.pvtAggregator').val();
    }
    // List chart type
    klass.chartType = function(){
        return klass.container.find('.pvtRenderer').val();
    }

    return klass;
}
