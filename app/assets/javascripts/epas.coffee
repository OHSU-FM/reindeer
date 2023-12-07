# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $('#WBATable').DataTable 'ordering': true, "pageLength": 25
  $('.dataTables_length').addClass 'bs-select'
  console.log("Inside epa.coffee file!")
