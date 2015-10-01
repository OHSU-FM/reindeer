#= require chroma.js

class LsChartMultNumeric
    constructor: (node, data) ->
        @node = $(node)
        @data = data

    draw: ->
        # Heatmap for 3rd row(local mean) 
        @heatmap_row(@node.find('tr td:nth-child(3)'))
        @heatmap_row(@node.find('tr td:nth-child(4)'))

        # Heatmap for 7rd row(pop mean) 
        @heatmap_row(@node.find('tr td:nth-child(7)'))
        @heatmap_row(@node.find('tr td:nth-child(8)'))

    heatmap_row: ($elems) ->
        vals = []
        $elems.each ->
            v = parseFloat($(this).text())
            vals.push(v)
        vals = $.unique(vals)
        cmap = chroma.scale(['blue', 'red']).domain(vals, 5, 'quantiles')
        $elems.each ->
            v = parseInt($(this).text())
            $(this).css('color', cmap(v).hex())

class LsChartYesNo
   
    constructor: (node, data) ->
        @node = $(node)
        @data = data
        @red = '#8a1540'
        @green = '#1f8040'
        @grey = '#777'
        return
   
    draw: ->
       @node.css('width', @data.percent)
       @node.css('height', 10)
       @node.css('background-color', @color())
       return

    color: ->
        if @data.code == 'N'
            return @red
        else if @data.code == 'Y' 
            return @green
        else
            return @grey

class LsChartGender
   
    constructor: (node, data) ->
        @node = $(node)
        @data = data
        @pink = 'pink'
        @blue = 'blue'
        @grey = '#777'
        return
   
    draw: ->
       @node.css('width', @data.percent)
       @node.css('height', 10)
       @node.css('background-color', @color())
       return

    color: ->
        if @data.code == 'M'
            return @blue
        else if @data.code == 'F' 
            return @pink
        else
            return @grey

class LsChartListDrop
    #
    # Mult Question codes can be assigned, so this does not work
    #
    constructor: (node, data) ->
        @.colors10 = [ '#1f8040', '#8a1540',  '#FFA500', '#ffcfb5', '#ff715e', '#437049', '#170bfa', '#2510a3', '#1f1050', '#000000']
        @.colors40 = [ '#1f8040', '#8a1540',  '#FFA500', '#fff57b', '#ffde9f', '#ffc8c1', '#ffbcc5', '#ffb3b7', '#ffa9a8', '#ff9f99', '#ff958b', '#ff897c', '#ff7e6e', '#ff715e', '#ff654f', '#ff563e', '#ff432c', '#ff2a17', '#ec3800', '#a86900', '#567c00', '#2d792a', '#4b6c58', '#575c7f', '#574ba6', '#4b34d0', '#170bfa', '#1305eb', '#1d0ad4', '#220dbf', '#240fab', '#251196', '#251183', '#24116f', '#21115c', '#1e1049', '#1a0f39', '#160a27', '#0f0518', '#000000']
        @node = $(node)
        @data = data
        return
    
    draw: ->
        @node.css('width', @data.percent)
        @node.css('height', 10)
        @node.css('background-color', @color())
        return
    
    color: ->
        return @colors10[@data.item_id] || @colors40[@data.item_id]

$(document).ready ->
    # Dont run if we are included by another page
    return if $('body').attr('id') != 'ls_reports_filter'

    window.scroll_spy_init(170) 

    # Sticky table header 
    $('body table.report').stickyTableHeaders({fixedOffset: $('.navbar') });
    

    # Utility function for toggle
    toggle_row = (node) ->
        row = $(node).parents('tr');
        open_row = row.find('.arrow-open');
        if(open_row.length > 0)
            hide_row(node);
        else
            show_row(node);
        return
    
    # hide sub row
    hide_row = (node) ->
        $(node).parents('tr').find('.arrow-open').removeClass('arrow-open').
            addClass('arrow-closed').parents('tr').next().find('.toggle-div').slideUp('slow', refresh);

    # show sub row
    show_row = (node) ->
        $(node).parents('tr').find('.arrow-closed').removeClass('arrow-closed').
            addClass('arrow-open').parents('tr').next().find('.toggle-div').slideDown('slow', refresh);

    # Open sub row when clicked
    $(document).on 'click', '.toggle-img', (event) ->
        toggle_row(this);

    # ??? 
    $('a.auto-colored-mean').each ->
        $(@).value

    # Load charts
    $('.ls-chart').each ->
        load_ls_chart.call @
    
    waypoint_handler = (direction, pos) ->
        waypoint = this
        waypoint.destroy()
        $target = $(this.element).trigger('ls_reports_filter:load')

    autoload_partial = ->
        load_partial($(this))
        for bg in $('.blank-gid')
            $bg = $(bg)
            if $bg? && $bg.isOnScreen()
                load_partial($bg)
        return

    load_partial = ($target) ->
        $anchor = $target.find('a')
        unless $target? && $anchor? && $anchor.length > 0
            #console.log('existential crisis')
            return
        if $target.data('already-loading')
            #console.log('already-loading')
            return
        $target.addClass('.blank-gid-loading').removeClass('.blank-gid')
        $target.data('already-loading', true)
        #console.log($target.prev().text().replace(/ /g,''))
        url = $anchor.attr('href')
        current_request = $.ajax({
            data_type: 'json',
            url: url,
            error: (data)->
                $target.html('
                <td colspan="13">
                    <div class="alert alert-warning">
                        Sorry! There was a server error while loading the data. We have been notified of the 
                        situation.
                    </div>
                </td>
                ')
            success: (data) ->
                # Get parent row
                $tr = $anchor.parents('tr.blank-gid')
                # Insert new data
                $html = $(data.html)
                $tr.before($html)
                #$tr.slideDown('slow')
                $html.find('.ls-chart').each ->
                    load_ls_chart.call @
                $tr.remove() # Remove parent row
                refresh() # Update navbar
         
        })
    
    blank_gids = $('.blank-gid')
    way_positions = ['170%', '100%', '50%', '5%']
    for pos in way_positions
        blank_gids.waypoint( (direction) ->
            waypoint_handler.call(this, direction, pos)
        , {offset: pos, continuous: false})

    $(document).on 'scroll-spy-nav:after-click', 'a', (e) ->
        $target = $($('.active a').attr('href')).next('.blank-gid') 
        $target.trigger('ls_reports_filter:load')
        return

    $(document).on 'ls_reports_filter:load', '.blank-gid', (e) ->
        autoload_partial.call(this)
    
    $(document).on 'click', '.partial-url', (e) ->
        autoload_partial.call(this)

    
    autoload_partial()
    refresh()
    return

##
# Call refresh for items on page that need it
refresh = ->
    $('body').scrollspy('refresh')
    Waypoint.refreshAll()
    $(window).trigger('resize.stickyTableHeaders');


window.load_ls_chart = ->
    data = $(@).data('chartData')
    return unless data
    switch data.qtype
        when "mult_numeric"
            chart = new LsChartMultNumeric(@, data)
            chart.draw()
        when "yes_no"
            chart = new LsChartYesNo(@, data)
            chart.draw()
        when  "mult"
            chart = new LsChartListDrop(@, data)
            chart.draw()
        when "list_drop"
            chart = new LsChartListDrop(@, data)
            chart.draw()
        when  "list_radio"
            chart = new LsChartListDrop(@, data)
            chart.draw()
        when  "arr_flex_child"
            chart = new LsChartListDrop(@, data)
            chart.draw()
        when  "dual_arr_child"
            chart = new LsChartListDrop(@, data)
            chart.draw()
        when  "mult_w_comments"
            chart = new LsChartListDrop(@, data)
            chart.draw()
        when  "gender"
            chart = new LsChartGender(@, data)
            chart.draw()
        else
            console.log('Unsupported chart type: ' + data.qtype)
    return



