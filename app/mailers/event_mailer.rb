class EventMailer < ApplicationMailer
  def notify_student (meeting, method)

      @event_mailer = Event.find(meeting.event_id)
      @meeting_mailer = meeting
      student_email = meeting.user.email # student email
      cc_email = Advisor.find_by(id: meeting.advisor_id).email  # advisor email
      emails = []
      if student_email == 'bettybogus@ohsu.edu'
        student_email = 'chungp@ohsu.edu'
      end
      emails << student_email
      emails << cc_email
      if method == "Create"
        subject_msg = "New Appointment with #{@event_mailer.description} on #{@event_mailer.start_date.strftime("%m/%d/%Y %I:%M %p - %A")}"
        @body_msg = "The appointment has been created.  Please be prepared to meet with " +
                     @event_mailer.description + " on " + @event_mailer.start_date.strftime("%m/%d/%Y %I:%M %p - %A") +  ".<br />" +
                     "You will receive additional details or a WebEx link from your Advisor before the scheduled appointment.<br />"
        log_emails(emails, "New Appointment: ", @event_mailer, subject_msg)
      elsif method == 'Cancel'
        subject_msg = "Your Appointment with #{@event_mailer.description} on #{@event_mailer.start_date.strftime("%m/%d/%Y %I:%M %p - %A")} has been canceled."
        @body_msg =  "The appointment with " + @event_mailer.description + " on " + @event_mailer.start_date.strftime("%m/%d/%Y %I:%M %p - %A") +
                      "has been canceled. <br /> <br /> "
        log_emails(emails, "Cancel Appointment: ", @event_mailer, subject_msg)
      end

      mail(to: emails, from: "chomina@ohsu.edu", subject: subject_msg)

  end

  def notify_student_advisor_appt_cancel (meeting)
      @event_mailer = Event.find(meeting.event_id)
      @meeting_mailer = meeting
      student_email = meeting.user.email # student email
      cc_email = Advisor.find_by(id: meeting.advisor_id).email  # advisor email
      emails = []

      emails << student_email
      emails << cc_email
      if student_email == 'bettybogus@ohsu.edu'
        student_email = 'chungp@ohsu.edu'
      end
      subject_msg = "Your Appointment with #{@event_mailer.description} on #{@event_mailer.start_date.strftime("%m/%d/%Y %I:%M %p - %A")} has been canceled."

      log_emails(emails, "Cancel Appointment: ", @event_mailer, @meeting_mailer)

      mail(to: emails, from: "chomina@ohsu.edu", subject: subject_msg)

  end

  def log_emails (to_emails, message, event_mailer, subject_msg)
    filename = "#{Rails.root}/log/email_notifications.log"
    File.open(filename,"a") do |f|
      f.write("===========================================================================\n")
      f.write(message + "\n")
      f.write("Emails sent on " + Time.now.strftime("%d/%m/%Y %H:%M") + "\n")
      f.write("Emails: " + to_emails.inspect + "\n")
      f.write("subject: " + subject_msg + "\n")
      f.write("===========================================================================\n")
    end
  end

end
