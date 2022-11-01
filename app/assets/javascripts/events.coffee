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
          if advisors[key].advisor_type.includes(advisorType)
            $('#advisor').append $('<option></option>').attr('value', advisors[key].id).text(advisors[key].name)
          else if advisorType.includes("Step 1")
            advisorType = "Academic"
            $('#advisor').append $('<option></option>').attr('value', advisors[key].id).text(advisors[key].name)
      #alert JSON.stringify(advisor)
      #$(this).text(advisor)
  return

appointments = []
next = 1;
window.addFormField = ->
  addto = "#startDate" + next;
  next = next + 1;
  newIn = '<br /><input type="datetime-local" autocomplete="off" class="span3" id="startDate' + next + '" name="startDate' + next + '" ><button id="b'+next+'" onClick="$(this).prev().remove();$(this).remove();" class="btn btn-warning" type="button">Remove</button>';
  newInput = $(newIn);
  console.log(addto);
  $(addto).after(newInput);
  if(next>1)
      $("button#b"+next).after(newInput);
  #$("#field" + next).attr('data-source',$(addto).attr('data-source'));
  $("#count").val(next);


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

  # $('#all_events_table').DataTable 'ordering': true
  #$('.dataTables_length').addClass 'bs-select'

  $('#all_events_table').dataTable 'oSearch': 'sSearch': $('#searchValue').val()
  #$('#pass_events_table').dataTable 'oSearch': 'sSearch': $('#searchValue').val()

  $('#pass_events_table').DataTable()
  $('.dataTables_length').addClass 'bs-select'
  #alert('searchValue: ' + $('#searchValue').val())
