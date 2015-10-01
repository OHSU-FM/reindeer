


jQuery(document).ready ->
    $ = jQuery;
    $.notifyDefaults({
        type: 'info'
        mouse_over: 'pause',
        placement:{
            from: 'top',
            align: 'right'
        },
        offset:{
            x: 10,
            y: 60
        }
        animate:{
            enter: 'animated fadeInUp',
            exit: 'animated fadeOutDown'
        }
    })

    # Automatic growl notifications on page load
    $('.auto-growl').each ->
        msg = $(this).text()
        $.notify(msg)
