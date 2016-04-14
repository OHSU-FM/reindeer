class User
  class ForgotPasswordService
    include ActiveModel::Validations 

    attr_accessor :login
    validates :login, presence: { message: 'Please enter a user name or email address'}
    validates :user, presence: { message: 'User not found!'}, if: Proc.new { |service| service.login.present? }
    
    def initialize(login)
      @login = login
      validate
    end

    def perform!
      return if errors.any?
      # Send email reminder
      raise hell
    rescue StandardError => e
      Rails.logger.error(e)
      errors.add :base, 'Oops! An error occured, no action was taken'
    end

    def user
      @user ||= User.find_login(login).first
    end
    
    def error_message
      errors.first[1]
    end

  end
end
