# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('.button').click ->
      $('#SearchForm').attr('onsubmit','return true;')
      return
  $('#SearchForm').attr('onsubmit','return false;')
  $('#SearchTable').dataTable  pageLength: 150, language: searchPlaceholder: 'FirstName or LastName'
