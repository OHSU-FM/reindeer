# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('#EpaQaTable').DataTable 'ordering': true
  $('.dataTables_length').addClass 'bs-select'
  $('#WbaEpaTable').DataTable 'ordering': true
  $('#WbaDetailTable').DataTable 'ordering': true
  $('.dataTables_length').addClass 'bs-select'
  $('#misMatchEGMember').change ->
    cohortId = $('#misMatchCohortId').val()
    if cohortId == ''
      alert("Please Select a Cohort!")
    return
