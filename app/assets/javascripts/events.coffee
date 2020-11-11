# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
appointments = []
$(document).ready ->
  $('#calendar').fullCalendar events: '/events.json'
  console.log ("Inside events.coffee!")
  #$('#calendar').fullCalendar({ });
  $('#SaveAll').click ->
    $.each $('input[name=\'checkbox\']:checked'), ->
      appointments.push $(this).val()
      return
    #console.log("appointments: " + appointments)
    #console.log("JSON: " + JSON.stringify(appointments))
    $.ajax
      url: '/events/save_all'
      type: 'get'
      data: appointments: JSON.stringify(appointments)
      dataType: 'json'
      success: (data) ->
        alert 'successfully ' + JSON.stringify(data)
        return
