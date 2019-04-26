# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  console.log "Inside students.coffee"
  $('#newGoalButton').click ->
    existGoalForm = $("#GoalForm")[0]
    if ( existGoalForm != null)
      $("#GoalForm")[0].reset();
    return
  $('#newMeetingButton').click ->
    existMeetingForm = $("#MeetingForm")[0]
    if (existMeetingForm != null)
      $("#MeetingForm")[0].reset();
    return
