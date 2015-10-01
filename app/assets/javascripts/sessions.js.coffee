#$(document).ready ->
#    was_logged_in = false
#    return if $('body').attr('id') == 'sessions'
#
#    check_timeout = ->
#        setTimeout ->
#            # Call ourselves again in 60 seconds
#            check_timeout()
#            # Check server for access
#            $.ajax({
#                data_type: 'json',
#                url: window.BASE_URL+'user_logged_in.json',
#                error: (xhr)->
#                    if xhr.status == 401 and was_logged_in == true
#                        window.location = window.BASE_URL
#                    return
#                success: (data, status, xhr) ->
#                    was_logged_in = true
#                    return
#            })
#        , 60000 # Every 60 seconds
#
#    # Fire timeout timer function
#    check_timeout()
