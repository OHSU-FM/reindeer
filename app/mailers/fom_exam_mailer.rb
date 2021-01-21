class FomExamMailer < ApplicationMailer
  def notify_student (user_ids, email_message)

      # @event_mailer = Event.find_by(id: meeting.event_id)
      # @meeting_mailer = meeting
      # student_email = meeting.user.email # student email
      # cc = Advisor.find_by(id: meeting.advisor_id).email  # advisor email
      # mail(to: 'chungp@ohsu.edu', subject: "New Appointment with #{@event_mailer.description} on #{@event_mailer.start_date.strftime("%m/%d/%Y %I:%M %p")}")

      from = email_message.select{|e| e if e["from"]}.first["from"]
      subject = email_message.select{|e| e if e["subject"]}.first["subject"]
      @body_message = email_message.select{|e| e if e["body_message"]}.first["body_message"]
      skip_emails = email_message.select{|e| e if e["skip_email"]}.first["skip_email"].map{|val| val["user_id"]}
    #byebug

  end
end
