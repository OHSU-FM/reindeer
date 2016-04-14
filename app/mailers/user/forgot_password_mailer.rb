class User::ForgotPasswordMailer < ActionMailer::Base
  def forgot_password_email(user)
    @user = user
    mail(to: @user.email, subject: 'Forgot Password')
  end
end
