# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class RoomChannel < ApplicationCable::Channel
  def subscribed
    current_user.rooms.each do |room|
      stream_from "room_channel_#{room.id}"
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak data
    Message.create! content: data['message'], user: current_user, room_id: data['roomNumber']
  end

  # TODO archive
  # def archive data
  #   @message = Message.find_by(id: data['messageId'])
  #
  #   if @message.nil?
  #     # TODO tell the client we couldn't find it
  #   end
  #
  #   @message.destroy
  # end

  def retract data
    @message = Message.find_by(id: data['messageId'])

    if @message.nil?
      # TODO tell the client we couldn't find it
    end

    @message.destroy
  end
end
