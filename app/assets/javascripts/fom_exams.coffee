
$(document).ready ->
  #alert("Inside form_exam.coffee")
  $('#check_all').click ->
    $('input:checkbox').prop 'checked', @checked
    return
