class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform message, user
    ActionCable.server.broadcast "room_channel_#{message.room_id}",
      message: render_message(message, user)
  end

  private

  def render_message message, user
    ApplicationController.renderer.render partial: 'messages/message', locals: { message: message, current_user: user }
  end
end
