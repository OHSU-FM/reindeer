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
    tempData = $('#IsAdvisor').data("isadvisor")
    console.log("IsAdvisor = " + tempData)
    if tempData == 'Yes'
      console.log("found IsAdvisor!")
      return
    advisorType = @value
    #alert advisorType
    $('#advisor').empty()
    $('div[data-advisors]' ).each ->
      advisors = $(this).data('advisors')
      for key of advisors
        if advisors.hasOwnProperty(key)
          #alert advisors[key].name
          if advisors[key].advisor_type.includes(advisorType)
            $('#advisor').append $('<option></option>').attr('value', advisors[key].id).text(advisors[key].name)
          else if advisorType.includes("Step 1") or advisorType.includes("Remediation")
            advisorType = "Academic"
            $('#advisor').append $('<option></option>').attr('value', advisors[key].id).text(advisors[key].name)
      #alert JSON.stringify(advisor)
      #$(this).text(advisor)
  return


appointments = []
next = 1;

window.addFormField = ->
  addto = "#rstartDate" + next;
  next = next + 1;
  newIn = '<br />' +
  '<label for="Weekly_Recurrences">Weekly recurrences</label>&nbsp;' +
  '<select name="weekly_recurrences' + next + '" id="weekly_recurrences' + next + '"> class="form-select"' +
  '<option value="0">0</option>' +
  '<option value="1">1</option>' +
  '<option value="2">2</option>' +
  '<option value="3">3</option>' +
  '<option value="4">4</option>' +
  '<option value="5">5</option>' +
  '<option value="6">6</option>' +
  '<option value="7">7</option>' +
  '<option value="8">8</option>' +
  '<option value="9">9</option>' +
  '<option value="10">10</option>' +
  '<option value="11">11</option>' +
  '<option value="12">12</option>' +
  '</select>&nbsp;' +
  '<input type="datetime-local" autocomplete="off" class="span3" id="rstartDate' + next + '" name="rstartDate' + next +
  '">' + '<button id="b'+ next + '"onClick="$(this).prev().remove();$(this).prev().remove();$(this).prev().remove();$(this).remove();" class="btn btn-warning btn-sm" type="button">Remove&nbsp;</button>';
  newInput = $(newIn);
  #console.log(addto);
  $(addto).after(newInput);
  $("#startDate" + next).after("&nbsp;") # add extra spacing before Remove button
  if(next>1)
      $("button#b"+next).after(newInput);
  #$("#field" + next).attr('data-source',$(addto).attr('data-source'));
  $("#count").val(next);

$ ->
  $('#datepicker').datepicker()
  return

roundMinutes = (date) ->
  if date.getMinutes() >= 30
    date.setHours date.getHours() + 1
  date.setMinutes 0
  return date

window.addEventListener 'load', ->
  flatpickr '#rstartDate1',
     allowInput: true,
     enableTime: true,
     # defaultDate: roundMinutes(new Date()),
     minTime: "07:00",
     maxTime: "20:00",
     altInput: true,
     altFormat: "F j, Y h:i K",
     dateFormat: "Y-m-d h:i K",
     minuteIncrement: 30,
     plugins: [
       new confirmDatePlugin()
     ]
    onChange: (dates, dateStr, instance) ->
      flatPickerChange dates, dateStr, instance
      return
    $('#endDate1').val($('#startDate1').val())
  return

window.addEventListener 'load', ->
  flatpickr '#rstartDate2',
     allowInput: true,
     enableTime: true,
     # defaultDate: roundMinutes(new Date()),
     minTime: "07:00",
     maxTime: "20:00",
     altInput: true,
     altFormat: "F j, Y h:i K",
     dateFormat: "Y-m-d h:i K",
     minuteIncrement: 30,
     plugins: [
       new confirmDatePlugin()
     ]
    onChange: (dates, dateStr, instance) ->
      flatPickerChange dates, dateStr, instance
      return
    $('#endDate1').val($('#startDate1').val())
  return

window.addEventListener 'load', ->
  flatpickr '#rstartDate3',
     allowInput: true,
     enableTime: true,
     # defaultDate: roundMinutes(new Date()),
     minTime: "07:00",
     maxTime: "20:00",
     altInput: true,
     altFormat: "F j, Y h:i K",
     dateFormat: "Y-m-d h:i K",
     minuteIncrement: 30,
     plugins: [
       new confirmDatePlugin()
     ]
    onChange: (dates, dateStr, instance) ->
      flatPickerChange dates, dateStr, instance
      return
    $('#endDate1').val($('#startDate1').val())
  return
window.addEventListener 'load', ->
  flatpickr '#startDate1',
     allowInput: true,
     enableTime: true,
     defaultDate: roundMinutes(new Date()),
     minTime: "07:00",
     maxTime: "20:00",
     altInput: true,
     altFormat: "F j, Y h:i K",
     dateFormat: "Y-m-d h:i K",
     minuteIncrement: 15,
     plugins: [
       new confirmDatePlugin()
     ]
    onChange: (dates, dateStr, instance) ->
      flatPickerChange dates, dateStr, instance
      return
    $('#endDate1').val($('#startDate1').val())
  return

add5Hours = ->
  startDate1 = $('#startDate1').val()
  newDate = new Date(startDate1)
  newDate.setHours(newDate.getHours() + 5);
  return newDate

window.addEventListener 'load', ->
  flatpickr '#endDate1',
     allowInput: true,
     enableTime: true,
     defaultDate: add5Hours(),
     minTime: "07:00",
     maxTime: "20:00",
     altInput: true,
     altFormat: "F j, Y h:i K",
     dateFormat: "Y-m-d h:i K",
     minuteIncrement: 15,
     plugins: [
       new confirmDatePlugin()
     ]
    onChange: (dates, dateStr, instance) ->
      flatPickerChange dates, dateStr, instance
      return
  return

window.addEventListener 'load', ->
  flatpickr '#startDateRetro',
     allowInput: true,
     enableTime: true,
     defaultDate: "today",
     #minTime: "07:00",
     maxTime: "20:00",
     dateFormat: "Y-m-d h:i K",
     minuteIncrement: 15,
     plugins: [
       new confirmDatePlugin()
     ]
    onChange: (dates, dateStr, instance) ->
      flatPickerChange dates, dateStr, instance
      return

  return

$(document).ready ->

  $('#startDate1').change ->
    newDate = add5Hours
    $('#endDate1').val(newDate)
    flatpickr '#endDate1',
       allowInput: true,
       enableTime: true,
       defaultDate: add5Hours(),
       minTime: "07:00",
       maxTime: "20:00",
       altInput: true,
       altFormat: "F j, Y h:i K",
       dateFormat: "Y-m-d h:i K",
       minuteIncrement: 30,
       plugins: [
         new confirmDatePlugin()
       ]
      onChange: (dates, dateStr, instance) ->
        flatPickerChange dates, dateStr, instance
        return
    return

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

  $('#all_events_table').dataTable language: searchPlaceholder: 'FirstName or LastName'
  #$('#pass_events_table').dataTable 'oSearch': 'sSearch': $('#searchValue').val()

  $('#pass_events_table').dataTable language: searchPlaceholder: 'FirstName or LastName'
  $('#send_invite_table').dataTable language: searchPlaceholder: 'FirstName or LastName'
  $('.dataTables_length').addClass 'bs-select'
  #alert('searchValue: ' + $('#searchValue').val())

  events = []
  $('#DeleteAll').click ->
    $.each $('input[name=\'checkbox\']:checked'), (K, V) ->
      events.push V.value
      return
    $.ajax
      url: '/events/delete_all'
      type: 'get'
      data: events: JSON.stringify(events)
      dataType: 'json'
      success: (data) ->
        # alert('All Appointments were successfully saved!');
        window.location = '/events/batch_delete'
        return
      error: (request, error) ->
        alert 'Request Reviews: ' + JSON.stringify(request)
        return
    return
