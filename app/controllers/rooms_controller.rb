class RoomsController < ApplicationController
  before_action :set_cookie

  def show
    @messages = Message.all
  end

  private

  def set_cookie
    cookies.encrypted[:user_id] = current_user.id
  end
end
