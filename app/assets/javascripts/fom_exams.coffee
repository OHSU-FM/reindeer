
$(document).ready ->
  #alert("Inside form_exam.coffee")
  $('#check_all').click ->
    $('input:checkbox').prop 'checked', @checked
    return
  $('#fomTable_comp1').DataTable 'ordering': true, "pageLength": 25
  $('#fomTable_comp2a').DataTable 'ordering': true, "pageLength": 25
  $('#fomTable_comp2b').DataTable 'ordering': true, "pageLength": 25
  $('#fomTable_comp3').DataTable 'ordering': true, "pageLength": 25
  $('#fomTable_comp4').DataTable 'ordering': true, "pageLength": 25
  $('#fomTable_comp5a').DataTable 'ordering': true, "pageLength": 25
  $('#fomTable_comp5b').DataTable 'ordering': true, "pageLength": 25
  $('#fomTable_summary').DataTable 'ordering': true, "pageLength": 25
  $('.dataTables_length').addClass 'bs-select'
