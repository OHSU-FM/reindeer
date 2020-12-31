# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('#advisor_type').change ->
    advisorType = @value
    #alert advisorType
    $('#advisor').empty()
    $('div[data-advisors]' ).each ->
      advisors = $(this).data('advisors')
      for key of advisors
        if advisors.hasOwnProperty(key)
          #alert advisors[key].name
          if advisors[key].advisor_type == advisorType
            $('#advisor').append $('<option></option>').attr('value', advisors[key].id).text(advisors[key].name)
      #alert JSON.stringify(advisor)
      #$(this).text(advisor)
  return

appointments = []
$(document).ready ->
  $("#startDate").val(new Date().toJSON().slice(0,19))

  $('#check_all').click ->
    $('input:checkbox').prop 'checked', @checked
    return

  $('#calendar').fullCalendar events: '/events.json'
  console.log ("Inside events.coffee!")
  #$('#calendar').fullCalendar({ });
  # $('#SaveAll').click ->
  #   $.each $('input[name=\'checkbox\']:checked'), ->
  #     appointments.push $(this).val()
  #     return
  #   #console.log("appointments: " + appointments)
  #   #console.log("JSON: " + JSON.stringify(appointments))
  #   $.ajax
  #     url: '/events/save_all'
  #     type: 'get'
  #     data: appointments: JSON.stringify(appointments)
  #     dataType: 'json'
  #     success: (data) ->
  #       alert 'All Appointments were successfully saved!'
  #       window.location = '/events'
  #       return
