module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verfied_user
    end

    private

    def find_verfied_user
      (current_user = env['warden'].user) ? current_user : reject_unauthorized_connection
      #if verified_user = User.find_by(id: cookies.encrypted[:user_id])
      #  verified_user
      #else
      #  reject_unauthorized_connection
      #end
    end
  end
end
