class RoomsController < ApplicationController
  layout 'full_width_margins'
  before_action :set_cookie
  before_action :set_room, only: [:show]

  def show
    @messages = Message.where(room_id: @room.id)
  end

  def index
    @rooms = Room.all
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end

  def set_cookie
    cookies.encrypted[:user_id] = current_user.id
  end
end
