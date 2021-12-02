class FomExamMailer < ApplicationMailer
  def notify_student (user, email_message)

      # mail(to: 'chungp@ohsu.edu', subject: "New Appointment with #{@event_mailer.description} on #{@event_mailer.start_date.strftime("%m/%d/%Y %I:%M %p")}")
      @user_mailer = user
      @email_message = email_message

      from = email_message.select{|e| e if e["from"]}.first["from"]
      subject = email_message.select{|e| e if e["subject"]}.first["subject"]
      @body_message = email_message.select{|e| e if e["body_message"]}.first["body_message"]

      mail(to: user.email, from: from, subject: subject)

  end
end
