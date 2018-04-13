window.cableCreate = (room_id) ->
  App.room = App.cable.subscriptions.create {channel: "RoomChannel", room_id: room_id },
    connected: ->
      # Called when the subscription is ready for use on the server

    disconnected: ->
      # Called when the subscription has been terminated by the server

    received: (data) ->
      console.log( JSON.stringify(data, null, "-->    "))
      console.log "messages: " + data['message']
      console.log "room_id: " + room_id

      if data['message']
        $('#room-id-' + room_id).append data['message']
        data['message'] = ""
      else if data['message_id']
        @removeMessage data['message_id']
      else
        console.log data

    speak: (message, roomNumber) ->
      @perform 'speak', message: message, roomNumber: roomNumber

    retract: (messageId) ->
      @perform 'retract', messageId: messageId

    removeMessage: (messageId) ->
      $('#message-' + messageId).remove()

updateScroll = (room_id) ->
  element = document.querySelector('#room-id-' + room_id)
  element.scrollTop = element.scrollHeight - element.clientHeight
  return

$(document).on 'keypress', '[data-behavior~=room_speaker]', (e) ->
  if e.keyCode is 13 # enter/return
    roomNumber = $("#room-identifier").data("room-number")
    msg = e.target.value
    App.room.speak(msg, roomNumber)
    e.target.value = ''
    msg = ""
    updateScroll(roomNumber)
    e.preventDefault()

$(document).on 'keypress', '[data-behavior~=room_speaker_goal]', (e) ->
  if e.keyCode is 13 # enter/return
    roomNumber = $("#room-identifier-goal").data("room-number")
    console.log ("goal keypress: " + "roomNumber: " + roomNumber)
    msg = e.target.value
    App.room.speak(msg, roomNumber)
    e.target.value = ''
    msg = ""
    e.preventDefault()

$(document).on 'keypress', '[data-behavior~=room_speaker_meeting]', (e) ->
  if e.keyCode is 13 # enter/return
    roomNumber = $("#room-identifier-meeting").data("room-number")
    console.log ("Meeting keypress: " + "roomNumber: " + roomNumber)
    msg = e.target.value
    App.room.speak(msg, roomNumber)
    e.target.value = ''
    msg = ""
    e.preventDefault()

$(document).on 'click', '.delete-message', (e) ->
  messageId = $(e.currentTarget).data('message-id')
  App.room.retract(messageId)
  # need to disable the button until we hear back from the channel
  e.preventDefault()

$(document).ready ->

  roomNumber = $("#room-identifier").data("room-number")
  window.cableCreate(roomNumber);


  #$("#general_comment_room").focusin ->
  #  $(this).css("border", "5px solid orange")
  #  room_id = $("#room-identifier").data("room-number")
    #alert ("general comment focusin: " + room_id)
  #  cableCreate(room_id)
  #  return



  return
