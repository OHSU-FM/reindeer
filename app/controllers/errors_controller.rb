class ErrorsController < ApplicationController
  skip_before_action :authenticate_user!

  def file_not_found
    respond_to do |format|
      format.html { render status: 404 }
    end
  rescue ActionController::UnknownFormat
    render status: 404, body: "not found"
  end

  def unprocessable
    respond_to do |format|
      format.html { render status: 422 }
    end
  rescue ActionController::UnknownFormat
    render status: 422, body: "not found"
  end

  def internal_server_error
    respond_to do |format|
      format.html { render status: 500 }
    end
  rescue ActionController::UnknownFormat
    render status: 500, body: "internal server error"
  end

  def not_authorized
    respond_to do |format|
      format.html { render status: 403 }
    end
  rescue ActionController::UnknownFormat
    render status: 403, body: "not authorized"
  end
end
