class MessageRetractJob < ApplicationJob
  queue_as :default

  def perform message
    ActionCable.server.broadcast "room_channel_#{message.room.id}",
      message_id: message.id
  end
end
