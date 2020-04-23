# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  console.log ("Inside CDS-report coffee script!")
  $('#PastDueForm').submit (e) ->
    e.preventDefault()
    placeholder = $('#startDate').val()
    @submit()

    console.log ("placeholder: " + placeholder)
    return

  return
