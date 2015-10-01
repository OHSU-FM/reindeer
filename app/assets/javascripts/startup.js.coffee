# Add s to html to indicate that js is enabled
document.getElementsByTagName('html')[0].className += ' jsEnabled';  

jQuery(document).ready ->
    $ = jQuery;

    # Mark link in the nav-bar as active
    jQuery("#nav-links li a."+controller_name+'-link').parent().addClass('active')

    # Show the modal "Page Loading" message if someone clicks on a modal-nav link
    $(document).on 'click', '.show-modal-nav-reports', ->
        $('#modal_nav_reports').modal('show');
        return
    
    # Show the modal "Page Loading" message if someone clicks on a modal-nav link
    $(document).on 'click', '.modal-click', ->
        $($(this).attr('data-target')).modal('show');
        return

    $(document).on 'change', '.modal-change', ->
        $($(this).attr('data-target')).modal('show');
        return
    
    # Automatically enable tooltips
    $('body').tooltip({selector:'[data-toggle="tooltip"]', trigger: 'hover focus', title: gen_title}).tooltip()

    ##
    # d-e-v and mouse click causes an easter egg 
    map = {68: false, 69: false, 86: false};
    $(document).keydown( (e) ->
        if map[e.keyCode] != undefined
            map[e.keyCode] = true;
     )       
        
    $(document).keyup( (e) ->
        if map[e.keyCode] != undefined
            map[e.keyCode] = false;
    );

    $(document).click((e) ->
        if map[68] && map[69] && map[86]
            $(e.target).addClass('fa-spin eggz-spin')
        else
            $('.eggz-spin').removeClass('fa-spin').removeClass('eggz-spin')
    )
    #
    # End of easter egg
    #
    
    return

# Title generator for tooltips
gen_title = ->
    $t = $(this)
    if $t[0].hasAttribute('data-tiptype')
        qtype = $t.data('tiptype')
        if qtype == 'qdesc'
            return window.LsReports.qtypes[$t.data('qtype')]
        else
            return 'Unknown tip type'
    else
        return $t.attr('title')

