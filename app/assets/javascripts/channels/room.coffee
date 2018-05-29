window.cableCreate = (room_id) ->
  App.room = App.cable.subscriptions.create {channel: "RoomChannel", room_id: room_id },
    connected: ->
      # Called when the subscription is ready for use on the server

    disconnected: ->
      # Called when the subscription has been terminated by the server

    received: (data) ->
      #console.log( JSON.stringify(data, null, "-->    "))
      console.log "messages: " + data['message']
      #console.log "room_id: " + room_id

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


$(document).on 'keypress', '[data-behavior~=room_speaker]', (e) ->
  $(".general-messages").scrollTop(10000)
  if e.keyCode is 13 # enter/return
    roomNumber = $("#room-identifier").data("room-number")
    window.cableCreate(roomNumber)
    msg = e.target.value
    App.room.speak(msg, roomNumber)
    e.target.value = ''
    msg = ""
    e.preventDefault()
    $(".general-messages").scrollTop(10000)
    console.log ("scrollHeight: " + $(".general-messages")[0].scrollHeight)

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
  $(".general-messages").scrollTop(10000)
  window.cableCreate(roomNumber)
  #:wconsole.log "room_id: " + roomNumber
  return
