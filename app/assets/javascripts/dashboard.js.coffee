# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
# require charts
#= require charts.js
#= require ls_reports_filter.js
#= require jquery.transform2d.js
#= require gridster/jquery.gridster.with-extras.js

###
# TODO:
#   - Dragging a widget and releasing (without actually moving) causes a POST
#   - POST should not re-render every widget unless needed
###

window.Dashboard = {};
window.Dashboard.swap_theme = (val)->
    $("body").removeClass (index, css) ->
        return $.makeArray(css.match (/\btheme-\S+/g) || []).join(' ')
    # Set new theme on body
    $('body').addClass( val )

window.Dashboard.Errors = {};

# A widget is too wide (from database)
class @Dashboard.Errors.WidgetTooWideError extends Error
    name: 'WidgetTooWideError'
    constructor: (@message) ->
# DB has colliding widgets
class @Dashboard.Errors.CollisionError extends Error 
    name: 'CollisionError'
    constructor: (@message) ->
class @Dashboard.Errors.ExhaustedError extends Error 
    name: 'ExhaustedError'
    constructor: (@message) ->
# DB has rectangle extending off the edge
class @Dashboard.Errors.RectangleOffTheEdgeError extends Error 
    name: 'RectangleOffTheEdgeError'
    constructor: (@message) ->
class @Dashboard.Errors.InvalidIdError extends Error 
    name: 'InvalidIdErro_'
    constructor: (@message) ->

window.WidgetLoader = {}

WidgetLoader.load = (charts, dash_widget) ->
        widget = dash_widget.widget
        unless widget?
            return
        unless widget.content?
            return
        console.log ('dash_widget.graph_type: ' + dash_widget.graph_type)
        # Grab target
        $target = $('#role-chart-widget_' + dash_widget.widget_id)
        content = widget.content
        switch dash_widget.widget_type
            when 'QuestionWidget'
                charts.push WidgetLoader.load_question_widget(dash_widget, widget, $target, content)

WidgetLoader.load_question_widget = (dash_widget, widget, $target, content) ->
    return switch widget.graph_type
        when 'html' 
            console.log('HTML Widget')
            widget.content.html
        else
            window.LsReport.Graph.load($target, dash_widget.widget.graph_type, content.stats, content.stats_u, content.series_name, content.unfiltered_series_name, content.filters_equal, content.widget_title)


##
# Creates a 2d array and maps items of different sizes to them
# - Used to ensure proper placement of desktop widgets
# - When max_cols != 5 we should prevent empty rows
class @Dashboard.CollisionDetector
        ##
        # Optionally set the maximum number of columns on 2d array
        #
        constructor: (opts={}) ->
            @max_cols = opts.max_cols || 5;
            @cm = [];
        
        ##
        # Register a rectangle in the collision matrix (cm) 
        # - Returns: index of insertion point if succeeds
        # - Or throws an error stating why it failed
        register_rectangle: (pos, sizex, sizey, rid) ->
            pos = Number pos
            sizex = Number sizex
            sizey = Number sizey
            rid = Number rid
            if !rid > 0
                throw new Dashboard.Errors.InvalidIdError()
            if sizex > @max_cols
                throw new Dashboard.Errors.WidgetTooWideError()
             
            # maximum number of times to try
            for attempt_num in [0..200]
                go_next_attempt = false
                c_pos = pos+attempt_num 
                console.log 'c_pos:' + c_pos
                
                try
                    # calculate what indecies this rectangle inhabits
                    indecies = @indexes_of c_pos, sizex, sizey
                catch e
                    if e instanceof Dashboard.Errors.RectangleOffTheEdgeError
                        console.log 'off edge'
                        continue
                    else
                        throw e
                 
                # check for collisions
                for idx in indecies
                    if @cm[idx] > 0
                        go_next_attempt = true
                        console.log 'next'
                        break
                
                if go_next_attempt == true
                    continue
                
                # mark spot as taken
                @set_indecies indecies, rid
                
                # return the start of the spot that was registered
                coords = @pos_to_coord Math.min.apply(Math, indecies)
                coords.rid = rid
                coords.pos = c_pos
                console.log 'pos: '+pos+' c_pos: '+ c_pos
                return coords
            
            throw new Dashboard.Errors.ExhaustedError();
        
        #
        # return all of the indexes that are occupied by the 
        # following rectangle
        #            
        indexes_of: (pos, sizex, sizey) ->
            indecies = []
            coord = @pos_to_coord(pos)
            if coord.col+(sizex-1) > @max_cols
                throw new Dashboard.Errors.RectangleOffTheEdgeError()
           
            for p_x in [0...sizex]
                console.log 'p_x: '+ p_x
                # add indecies for every row and col
                for p_y in [0...sizey]
                    console.log 'p_y: '+ p_y
                    n_pos = @coord_to_pos coord.col+p_x, coord.row+p_y
                    indecies.push n_pos
            return indecies
        
        #
        # Set the value of these indecies to rid
        # - Effectively take ownership of the indexes
        set_indecies: (indecies, rid=1) ->
            for index in indecies
                if !( typeof(@cm[index]) == 'undefined')
                    throw new Dashboard.Errors.CollisionError()
                @cm[index] = rid
            return true
        
        #
        # get the col and row of this position
        #
        pos_to_coord: (val) ->
            return { col: ((val-1) % (@max_cols))+1, row: parseInt((val-1) / (@max_cols))+1 }
        
        #
        # get the position of this col and row
        #
        coord_to_pos: (col, row) ->
            return ((row-1)*@max_cols + col)

#Gui Errors
window.Dashboard.GuiErrors = {}

##
#
class @Dashboard.GuiErrors.PositionMissingError extends Error
    name: 'PositionMissingError'
    constructor: (@message) ->

##
# 
class @Dashboard.GuiErrors.WidgetMissingError extends Error
    name: 'WidgetMissingError'
    constructor: (@message) ->

##
#
class @Dashboard.Widget

    constructor: (@node, opts={}) ->
        # A new widget is born
        @node = $(@node);

    replace: ->
        # Ajax replace the node with fresh data from the server

    data_to_form: ->
        # Update form data with information from data attributes

##
# Controls for dashboard
class @Dashboard.Gui
    
    ##
    #
    constructor: (container, opts={}) ->
        # A new Dashboard is born
        @container = $(container);
        @node = $(@container).find('form.dashboard-container');
        @widget_dimensions = opts.widget_dimensions || [200, 200]
        @min_cols = opts.min_cols || 2
        @max_cols = opts.max_cols || 5
        @margins = opts.margins || [5, 5]
        @refreshing = false
        @detector = new Dashboard.CollisionDetector({max_cols:@max_cols})
        return;
    
    ##
    #
    gridify: ->
        # Change into gridded dashboard
        klass = @
        @detect_and_repair_collisions()
        @gridster = @node.find(".gridster > ul").gridster({
            widget_margins: @margins,
            widget_base_dimensions: @widget_dimensions,
            min_cols: @min_cols,
            max_cols: @max_cols,
            extra_rows: 1,
            resize: {
                enabled: true,
                resize: (event, ui, $widget) ->
                    klass.auto_resize_widget($widget)
                    return
                stop: (event, ui, $widget) ->
                    klass.auto_resize_widget($widget)
                    # Update and submit changes after a resize event
                    klass.update_and_submit()
                    return
            }
            draggable: {
                stop: (event, ui) ->
                    # Update and submit changes after a drag event
                    klass.update_and_submit()
                    return
            }
        }).data('gridster'); 
        @event_handlers();
    
    ##
    # Automatically resize all widgets
    auto_resize_widgets: ->
        klass = @
        @widgets().each ->
            klass.auto_resize_widget($(@)) 
        return   

    ##
    # Automatically resize this widget
    auto_resize_widget: ($widget) ->
        $hook = $widget.find('.widget-resize-hook')
        # $table = $widget.find('.widget-table')
        wratio = ($widget.width()-30) / $hook.width() 
        hratio =   ($widget.height()-80) / $hook.height()
        if wratio > hratio
            wratio = hratio
        else
            hratio = wratio
        $hook.css({'transform':'scale(' + wratio + ','+hratio+')'})

    ##
    # Find and return all widgets
    widgets: ->
        @node.find('.gridster > ul > li');

    ##
    # Update and submit dashboard form
    update_and_submit: ->
        @update_widgets()
        console.log('Triggered a save')
        @node.trigger('submit.rails')
        return 
   
    ##
    # refresh form data for all widgets in this dash
    update_widgets: ->
        klass = @
        klass.widgets().each ->
            klass.update_widget(this)

    ##
    # move attribute data into form
    update_widget: (element) ->
        widget = $(element)
        col = parseInt(widget.attr('data-col')) || 1
        row = parseInt(widget.attr('data-row')) || 1
        pos = @detector.coord_to_pos(col, row)
        sizex = parseInt(widget.attr('data-sizex')) || 1
        sizey = parseInt(widget.attr('data-sizey')) || 1
        widget.find('.sizex').val(sizex)
        widget.find('.sizey').val(sizey)
        widget.find('.position').val(pos) 

    ##
    # Input widget positions into collision detector 
    # and update data attributes accordingly
    detect_and_repair_collisions: ->
        klass = @
        rid = 0
        @widgets().each ->
            # Only update widgets that have input contents
            if $(this).find('input').length == 0
                return

            pos = parseInt( $(this).find('.position').val() ) || 1
            sizex = parseInt( $(this).find('.sizex').val() ) || 1
            sizey = parseInt( $(this).find('.sizey').val() ) || 1
            rid += 1
            coords = klass.detector.register_rectangle(pos, sizex, sizey, rid)
            $(this).find('.position').val(coords.pos)
            $(this).attr('data-col', coords.col)
            $(this).attr('data-row', coords.row)
            $(this).attr('data-sizex', sizex)
            $(this).attr('data-sizey', sizey)
            $(this).attr('data-rid', coords.rid)
            klass.update_widget(this)

    ##
    #
    event_handlers: ->
        klass = @;
       
        # Screen reorientation change (mobile)
        @node.on 'oreientationchange', (event) ->
            klass.auto_resize_widgets()

        # Config for cocoon add nested fields
        @node.find('#dashboard-add')
            .data('association-insertion-position', 'after')
            .data('association-insertion-node', '');
        
        # The theme for the page has changed
        @node.on 'change', 'input[type="radio"].toggle-theme', (evt, element) ->
            window.Dashboard.swap_theme( this.value )
            # Update Form
            klass.update_and_submit()
            return;
        
        # Update record after a change
        @node.on 'change', '.dashboard-navbar select', (evt) ->
            klass.update_and_submit()
            return;

        # Add widget to gridster after cocoon adds it
        @node.on 'cocoon:after-insert', (evt, element) ->
            console.log('cocoon:after-insert');
            klass.gridster.add_widget(element, 1, 1);
            klass.update_and_submit()
            return;
        
        # Event triggered after form has been successfully updated
        @node.on 'ajax:success', (event, xhr, status) ->
            # Delete widgets that are marked for deletion
            console.log('form ajax success')
            klass.remove_deleted_widgets()
            klass.replace_created_widgets(xhr)
            klass.replace_stale_widgets(xhr)
            return;
        
        @node.on 'ajax:error', (event, xhr, status) ->
            # Delete widgets that are marked for deletion
            console.log('form ajax error')
            klass.node.addClass('ajax-error')
            return;
        
        @node.on 'ajax:beforeSend', (event, xhr, status) ->
            console.log('form ajax beforeSend')
            klass.disable_all_inputs()
            return;

        @node.on 'ajax:complete', (event, xhr, status) ->
            console.log('form ajax complete')
            klass.enable_all_inputs()
            return;
        
        # a widget will be removed from the form
        @node.on 'cocoon:before-remove', (evt, element) ->
            console.log('cocoon:before-remove')
            $(element).addClass('delete-after-update')
            return;
        
        # a widget has been removed from the form
        @node.on 'cocoon:after-remove', (evt, element) ->
            console.log('cocoon:after-remove')
            klass.update_and_submit()
            return;
        
        # a select has changed on the form
        @node.on 'change', '.radio-select input[type="radio"]', (evt, element) ->
            $(this).parents('.radio-select').children('li').each ->
                $(this).removeClass('selected');
            $(this).parents('li').addClass('selected');
            return;
         
        @node.on 'show.bs.modal', '.gridster .modal', (evt, element) ->
            klass.unpack_modal($(this))                            # Move form so that modal isn't broken 
            console.log 'a modal was shown' 
            return
        
        @node.on 'hide.bs.modal', '.gridster .modal', (evt, element) ->
            klass.repack_modal($(this))                            # Move form back to original place
            console.log 'a modal was closed'
            return

        # Select box change event for widget element
        @node.on 'change', '.gridster select', (evt, element) ->
            $(this).parents('li.nested-fields').addClass('replace-after-update')
            klass.update_and_submit() 
            return

        # Someone double-clicked on a widget
        @node.on 'dblclick tap', '.widget-content', (evt, element) ->
            $widget_title = $(this).parents('li.gs-w').find('.widget-title-container').clone()

            # Get node to move
            $node = $(this).find('.chart-visualization')
            # Create a copy of node and put a marker next to it
            $clone = $node.clone()
            $marker = $('<div id="modal-marker"></div>').append($clone)
            # put clone before original
            $node.before($marker)
            # move original into modal
            $('#modal_blank .modal-body').empty().append($node)
            $('#modal_blank .modal-header button').after($widget_title)
            $('#modal_blank').modal('show')
        
        # Update size after shown
        $('#modal_blank').on 'shown.bs.modal', (evt, element) ->
            klass.auto_resize_widget($('#modal_blank .modal-content'))
        
        # Update the size of the contained chart on orientation change (ipad etc...)
        $('#modal_blank').on 'orientationchange', (evt, element) ->
            klass.auto_resize_widget($('#modal_blank .modal-content')) 
        
        # Move contents back home
        $('#modal_blank').on 'hide.bs.modal', (evt, element) ->
            # Replace editable title
            $widget = $('#modal-marker').parents('.gs-w')
            $new_title=$(this).find('.modal-header .widget-title-container')
            $old_title = $widget.find('.widget-title-container')
            $old_title.before($new_title)
            $old_title.remove()
            
            $node = $(this).find('.modal-body').children()
            $('#modal-marker').after($node)
            
            # Clean up and re-size widgets
            $('#modal-marker').remove()
            klass.auto_resize_widget($widget)
            if $new_title.data('changed') == true
                klass.update_and_submit()

        #
        @node.on 'change', 'input[type="radio"].toggle-widget-type', (evt, element) ->
            $(this).parents('li.nested-fields').addClass('replace-after-update')
            # Update Form
            klass.update_and_submit()
            return;

        return # End of EventHandlers Function
    
    ##
    #
    max_cols: ->
        # determine max num of cells to use
        grid_width = Math.floor($(window).width()/@cell_size);
        # determine largest cell
        cell_widths = $.makeArray( @node.find('li.gs-w') ).map (val, i) ->
            $(val).data('sizex')||0;
        cell_width = Math.max.apply( null, cell_widths);
        # return the larger of the two
        Math.max.apply null, [cell_width, grid_width]
 
    ##
    # Return the minimum width of the dashboard
    dash_min_width: ->
        @max_cols() * @cell_size

    ##
    # Copy and replace old grid
    refresh: -> 
        if @refreshing == true
            return;
        @refreshing = true
        
        @node.find('ul').find('li.gs-w')
            .removeData('col')
            .removeData('row')
            .removeClass('gs-w');
        grid_clone = @node.children('ul').clone();
        grid_parent = @node.children('ul').parent();
        grid_clone.removeAttr 'style'
        @node.children('ul').remove();
        grid_parent.append(grid_clone);
        #$('#dash').css('min-width', klass.dash_min_width())
        @gridify();
        @refreshing = false
        return; 

    ##
    # Called after ajax:success to remove widgets that were deleted
    remove_deleted_widgets: ->
        klass = @
        # Delete widgets that are marked for deletion
        klass.node.find('.delete-after-update').each ->
            # Since the form has already been submitted we can remove cocoon hidden fields
            $(this).next('input[type="hidden"]').remove()
            # Update grid as well
            klass.gridster.remove_widget(this)
            return
    
    ##
    # Called after ajax:success to replace widgets that were originally marked with 'new-record' css class
    replace_created_widgets: (xhr) ->
        klass = @
        klass.node.find('.new-record').each ->
            widget_pos = parseInt( $(this).find('input.position').val() )
            new_widget = klass.widget_at_pos(xhr, widget_pos)
            $(this).removeClass('new-record')
            $(this).removeClass('replace-after-update')
            $(this).find('div.inner-widget-container').replaceWith(new_widget)
            return
        return
    
    ##
    # Called after ajax:success to replace widgets that need to be redrawn
    replace_stale_widgets: (xhr) ->
        klass = @
        $(xhr).find('.refresh-widget div.inner-widget-container').each ->
            # get position of widget
            widget_id = parseInt( $(this).find('input.widget-id').val() )
            # get current live widget
            $id_marker = klass.node.find('input.widget-id[value="'+widget_id+'"]')
            $old = $id_marker.parents('div.inner-widget-container')
            # get modal form for that widget
            $modal = klass.node.find('.gridster > .modal')
            if $modal.length > 0
                # make sure that modal form is where it belongs
                # before we update the $widget content
                klass.partially_repack_modal($modal)
             # replace widget with new widget
            $old.replaceWith(this)
            # Get new widget
            $widget = $(this).parents('li.gs-w')
            if $modal.length > 0
                # Update modal screen if one was open
                klass.partially_unpack_modal($widget.find('.modal'))
            # refresh widget contents (only if needed)
            klass.redraw_widget $widget
            return
        return

    ##
    # Move modal back so that everything is where it belongs
    repack_modal: ($modal, completely=true) ->
        $target = @node.find( $modal.attr('data-target') )      # Get target for where to return form
        $modal.insertAfter($target)                             # Move form back to original place 
        return

    ##
    # Move form so that modal isn't broken
    unpack_modal: ($modal) ->
        $modal.appendTo(@node.find('.gridster'))                # Move outside of absolutely pos element
        return                                                  #  So that modal displays properly

    ##
    # Move modal back so that form elements are where they belong
    partially_repack_modal: ($modal) ->
        $target = @node.find( $modal.attr('data-target') )      # Get target for where to return form
        $modal.clone().insertAfter($target)                     # Move a copy back in to place
        $modal.find('.modal-body').replaceWith('<div class="modal-body spinner-toggle"></div>')
        return

    ##
    # Remove this modal form and over-write an already unpacked modal form
    partially_unpack_modal: ($modal) ->
        # find unpacked modal
        $unpacked = @node.find('.gridster > .modal')
        if !$unpacked?
            return
        # swap out modal body
        $unpacked.find('.modal-body').replaceWith($modal.find('.modal-body'))
        # remove self now that everything is unpacked
        $modal.remove()
        return

    ##
    # Initialize and re-generate the contents of a widget
    # - also hide contents temporarily if new
    redraw_widget: ($widget) ->
        klass = @
        $widget.find('.chart-container-outer').each ->
            chart = new Chart(this);
            setTimeout (-> 
                # resize widget contents to stay inside of widget
                klass.auto_resize_widget($widget)
                # Show widget contents after resize has occurred
                $widget.find('.spin-toggle').removeClass('spin-toggle')
            ), 100
            return
        return

    ##
    # Find and return a widget at a position
    widget_at_pos: (xhr, pos) ->
        klass = @
        # Ensure that position is a positive integer
        if (pos > 0) == false
            throw new Dashboard.GuiErrors.PositionMissingError()
        # Ensure that we found a widget at the position
        match = $(xhr).find('.gridster li input.position[value="'+pos+'"]').first()
        if match.length == 0
            throw new Dashboard.GuiErrors.WidgetMissingError()
        return $(match).parents('div.inner-widget-container')   

    ##
    #
    disable_all_inputs: ->
        # disable all input methods for the dashboard
        @node.add('#modal_blank').find('.add_fields, .remove_fields, input').prop("disabled", true);

    ##
    #
    enable_all_inputs: ->
        # Enable all input methods for the dashboard
        @node.add('#modal_blank').find('.add_fields, .remove_fields, input').not('.disabled').prop("disabled", false);


### Node layout of dashboard
#
    div.dashboard-container-outer
        form.dashboard-container
            div.dashboard-container-inner
                div.dashboard-navbar
                    a#dashboard-add.add_fields
                    button#dashboard-save
                div.gridster
                    ul
                        li.gs-w
                            div.inner-widget-container
                                div.widget-controls
                                    a.remove_fields    
                                div.widget-content
                                    div.widget-show
                                    div.widget-edit
                            span.gs-resize-handle
###

$(document).ready ->
    return if $('body').attr('id') != 'dashboard'

    # Debug ability, add variables to global namespace
    window.dashboards = []
    window.charts = [];

    $(document).on 'cross-tabs:dashboard:theme-changed', (e, val)->
        window.Dashboard.swap_theme(val)

    # Bail unless we have gon data to process
    return unless gon?
    return unless gon.dashboard_widgets?
    $(gon.dashboard_widgets).each (idx, dash_widget) ->
        charts.push(WidgetLoader.load(charts, dash_widget))

    # Create charts
    $('.chart-container-outer').each ->
        charts.push( new Chart(this) );

    # Load charts
    $('.ls-chart').each ->
        load_ls_chart.call @

    $(document).on 'change', '.widget-title-container input', (evt, element) ->
        $(this).attr('value', this.value).
            parents('.widget-title-container').
            data('changed', true).
            find('p').text(this.value).
            attr('data-original-title', this.value)

    # Create dashboard(s)
    $('.dashboard-container-outer').each ->
        # Init and set options
        dashboard = new Dashboard.Gui( this, {max_cols: 6})
        # Create gridded dashboard
        dashboard.gridify();
        # Reveal widgets after timeout
        setTimeout (-> 
            # resize widget contents to stay inside of widget
            dashboard.auto_resize_widgets()
            # Show widget contents after resize has occurred
            dashboard.node.find('.spin-toggle').removeClass('spin-toggle');
        ), 600
        # Add to global for debug
        window.dashboards.push(dashboard)
    
    return;



