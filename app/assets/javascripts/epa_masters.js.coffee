# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('#get_EPA').click ->
    alert 'Get_EPA!'
    user_id = $("#user_id :selected").val()
    #user_temp = $('#user_id :selected').text()
    #alert("user_temp: " + user_temp)
    console.log ("user_id: " + user_id)
    $.ajax
      url: '/epa_masters/get_by_user/' + user_id
      method: 'GET'
      dataType: 'text'
      data: user_id: user_id
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (response) ->
        console.log (response)
        console.log("Getting epa_master via ajax!")

    return
  return
