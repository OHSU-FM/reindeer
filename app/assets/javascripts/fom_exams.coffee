
$(document).ready ->
  #alert("Inside form_exam.coffee")
  $('#check_all').click ->
    $('input:checkbox').prop 'checked', @checked
    return
  $('#fomTable').DataTable 'ordering': true
  $('.dataTables_length').addClass 'bs-select'
