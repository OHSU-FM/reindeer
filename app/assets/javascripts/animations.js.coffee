$(document).ready ->
    # Avoid z-index problem with css3 animations
  setTimeout (->
    if $('.alert').is(':visible')
      #you may add animate.css class for fancy fadeout
      $('.alert').fadeOut 'fast'
    return
  ), 3000
  return
