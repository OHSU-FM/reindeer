$(document).on 'keypress', '[data-behavior~=room_speaker]', (e) ->
  if e.keyCode is 13 # enter/return
    roomNumber = $("#room-identifier").data("room-number")
    App.room.speak(e.target.value, roomNumber)
    e.target.value = ''
    e.preventDefault()

$(document).on 'click', '.delete-message', (e) ->
  messageId = $(e.currentTarget).data('message-id')
  App.room.retract(messageId)
  # need to disable the button until we hear back from the channel
  e.preventDefault()

$(document).ready ->
  window.room_id = $("#room-identifier").data("room-number")

  App.room = App.cable.subscriptions.create { channel: "RoomChannel", room_id: window.room_id },
    connected: ->
      # Called when the subscription is ready for use on the server

    disconnected: ->
      # Called when the subscription has been terminated by the server

    received: (data) ->
      if data['message']
        $('#general-messages').append data['message']
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

  return
