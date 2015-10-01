$(document).ready ->
    # Avoid z-index problem with css3 animations
    setTimeout (->
        $('.fade-in').removeClass('fade-in')
        ), 1500
    return

