# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# $(document).ready ->
#     #$("#SearchInputForm *").prop("disabled", true)
#   console.log ("inside Searches CoffeeScript ***")
#   $("#SearchForm").on("ajax:success", (e, data, status, xhr) ->
#     console.log ("ajax call success!")
#   ).on "ajax:error", (e, xhr, status, error) ->
#     console.log ("Ajax error")
myFunction = ->
  console.log ("inside myFunction")
  $("#MeetingForm")[0].reset()
  return

$(document).ready ->
  $('.button').click ->
      $('#SearchForm').attr('onsubmit','return true;')
      return
  $('#SearchForm').attr('onsubmit','return false;')
  console.log ("inside searches cofffeescript!")

## Meeting Form
