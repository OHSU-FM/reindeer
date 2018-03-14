# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class RoomChannel < ApplicationCable::Channel

  def subscribed
    if !params[:room_id].nil?
      stream_from "room_channel_#{params[:room_id]}"
    end
  end

  def unsubscribed
      stop_all_streams
    # Any cleanup needed when channel is unsubscribed
  end

  def speak data
    if data['message'] != ""
      Message.create! content: data['message'], user: current_user, room_id: data['roomNumber']
     end
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
