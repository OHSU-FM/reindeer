# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $('#CollapsibleWbaTable').DataTable 'ordering': true
  $('.dataTables_length').addClass 'bs-select'
  $('[data-toggle="tooltip"]').tooltip()
  return
