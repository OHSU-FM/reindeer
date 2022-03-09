# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
# = require charts
# = require charts.js
# = require ls_reports_filter.js
# = require jquery.transform2d.js
# = require gridster/jquery.gridster.with-extras.js

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


$(document).ready ->

    return if $('body').attr('id') != 'dashboard'

    toggler = document.getElementsByClassName('caret')
    i = undefined
    i = 0
    while i < toggler.length
      toggler[i].addEventListener 'click', ->
        @parentElement.querySelector('.nested').classList.toggle 'active'
        @classList.toggle 'caret-down'
        return
      i++

    # Debug ability, add variables to global namespace
    window.dashboards = []
    #window.charts = [];

    $(document).on 'cross-tabs:dashboard:theme-changed', (e, val)->
        window.Dashboard.swap_theme(val)

    # Bail unless we have gon data to process
    return unless gon?
    #return unless gon.dashboard_widgets?



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
