App.room = App.cable.subscriptions.create { channel: "RoomChannel", room: 'test' },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $('#messages').append data['message']
    # easiest:
    # alert(data['message'])

  speak: (message) ->
    @perform 'speak', message: message

$(document).on 'keypress', '[data-behavior~=room_speaker]', (e) ->
  if e.keyCode is 13 # enter/return
    App.room.speak e.target.value
    e.target.value = ''
    e.preventDefault()
