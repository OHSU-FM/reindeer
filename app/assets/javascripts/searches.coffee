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

$(document).ready ->
  $('.button').click ->
      $('#SearchForm').attr('onsubmit','return true;')
      return
  $('#SearchForm').attr('onsubmit','return false;')

  # $('#course_code a').click ->
  #   courseCode = $(this).data("course-code")
  #   alert ("Search -> courseCode: " + courseCode)
  #   $.ajax
  #     dataType: 'json'
  #     type: 'GET'
  #     url: '/fom_exams/display_fom'
  #     data: course_code:  JSON.stringify(courseCode)
  #     success: (data) ->
  #       alert 'data: ' + JSON.stringify(data)
  #       return
  #     error: (request, error) ->
  #       alert 'Request Reviews: ' + JSON.stringify(request)
  #       return
  #
  #   return


## Meeting Form
