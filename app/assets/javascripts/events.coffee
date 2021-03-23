# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
dateName = (yyyy, mm, dd) ->

  monthNames = [
    'January'
    'February'
    'March'
    'April'
    'May'
    'June'
    'July'
    'August'
    'September'
    'October'
    'November'
    'December'
  ]
  dayNames = [
    'Sunday'
    'Monday'
    'Tuesday'
    'Wednesday'
    'Thursday'
    'Friday'
    'Saturday'
  ]
  today = new Date(yyyy, mm-1, dd)
  dd = today.getDate()
  dayname = dayNames[today.getDay()]
  mm = monthNames[today.getMonth()]
  yyyy = today.getFullYear()
  fullDate = dayname + ' ' + dd + ' ' + mm + ' ' + yyyy
  #alert 'the current date is: ' + fullDate
  return dayname

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
  yyyy = $("#start_date_start_date_1i").val()
  mm = $("#start_date_start_date_2i").val()
  dd = $("#start_date_start_date_3i").val()
  $("#start_weekday").val(dateName(yyyy, mm, dd))
  $("#end_weekday").val(dateName(yyyy, mm, dd))

  $("#startDate").val(new Date().toJSON().slice(0,19))

  $('#check_all').click ->
    $('input:checkbox').prop 'checked', @checked
    return

  $('#calendar').fullCalendar events: '/events.json'
  console.log ("Inside events.coffee!")

  $('[id^="start_date_start_date"]').change ->
    yyyy = $("#start_date_start_date_1i").val()
    mm = $("#start_date_start_date_2i").val()
    dd = $("#start_date_start_date_3i").val()
    #alert("YYYY+MM+DD: " + yyyy + "/" + mm + "/" + dd)
    $("#end_date_end_date_1i").val($("#start_date_start_date_1i").val())
    $("#end_date_end_date_2i").val($("#start_date_start_date_2i").val())
    $("#end_date_end_date_3i").val($("#start_date_start_date_3i").val())
    $("#start_weekday").val(dateName(yyyy, mm, dd))
    $("#end_weekday").val(dateName(yyyy, mm, dd))
    #alert(dateName(yyyy, mm, dd))


  $('#myInput').on 'keyup', ->
    value = $(this).val().toLowerCase()
    $('#all_events_table tr').not('thead tr').filter ->
      $(this).toggle $(this).text().toLowerCase().indexOf(value) > -1
      return
    return


    # alert("Start_Date: " + yyyy + "/" + mm + "/" + dd )
    # dayInformation = String(moment(yyyy+"-"+mm+"-"+dd))
    # alert(dayInformation)

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