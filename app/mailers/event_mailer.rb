class EventMailer < ApplicationMailer

  SENDER_SIGN = "Thanks!\n" +
                "OASIS Team\n" +
                "Erika Chomina Lenford\n" +
                "OASIS Program Manager\n" +
                "OHSU School of Medicine|UME\n" +
                "chomina@ohsu.edu"

  def notify_student (meeting, method)

      @event_mailer = Event.find(meeting.event_id)
      @meeting_mailer = meeting

      student_email = meeting.user.email # student email
      full_name = meeting.user.full_name
      first_name = full_name.split(", ").last
      advisor = Advisor.find_by(id: meeting.advisor_id) # advisor email
      advisor_type = advisor.advisor_type
      advisor_name = advisor.name
      cc_email = advisor.email
      username = cc_email.split('@').first
      emails = []
      if student_email == 'bettybogus@ohsu.edu'
        student_email = 'chungp@ohsu.edu'
      end
      emails << student_email
      emails << cc_email
      @event_mailer.description = @event_mailer.description.split(" - ").first + " - " + "Dr. " + advisor.name

      if advisor.advisor_type == 'Assist Dean'
        emails << "bazhaw@ohsu.edu"   ## assist dean assistance
        @event_mailer.description = @event_mailer.description.gsub(' Advisor', '')
      end

      if method == "Create" or method == 'Resend'
        if method == 'Create'

          subject_msg = "New Appt: #{advisor_type } Advising for #{full_name} with Dr. #{advisor_name} on #{@event_mailer.start_date.strftime("%m/%d/%Y %I:%M %p - %A")}"
          #subject_msg = "New Appointment with #{@event_mailer.description} on #{@event_mailer.start_date.strftime("%m/%d/%Y %I:%M %p - %A")}"
        else
          subject_msg = "** Resending New Appointment with #{@event_mailer.description} on #{@event_mailer.start_date.strftime("%m/%d/%Y %I:%M %p - %A")}"
        end
        @cal_body_msg = "The appointment has been created in REDEI.  Please be prepared to meet with " +
                     @event_mailer.description + " on " + @event_mailer.start_date.strftime("%m/%d/%Y %I:%M %p - %A") +  ".\\n\\n" +
                     "Student Name - #{full_name} (#{student_email})\\n" +
                     "#{@event_mailer.description} (#{cc_email})\\n\\n" +
                     "Here is the advisor personal WebEx link: \\n" +
                     "https://ohsu.webex.com/meet/#{username}\\n\\n\\n"

       @body_msg = "The appointment has been created in REDEI.  Please be prepared to meet with " +
                    @event_mailer.description + " on " + @event_mailer.start_date.strftime("%m/%d/%Y %I:%M %p - %A") +  ".<br><br>" +
                    "Student Name - #{full_name} (#{student_email})<br>" +
                    "#{@event_mailer.description} (#{cc_email})<br><br>" +
                    "Here is the advisor personal WebEx link: <br>" +
                    "https://ohsu.webex.com/meet/#{username}<br><br><br>"

        if method == 'Create'
          log_emails(emails, "New Appointment: ", @event_mailer, subject_msg)
        else
          log_emails(emails, "**Resent New Appointment: ", @event_mailer, subject_msg)
        end

      elsif method == 'Cancel'
        subject_msg = "Canceled: #{advisor_type } Advising for #{full_name} with Dr. #{advisor_name}  on #{@event_mailer.start_date.strftime("%m/%d/%Y %I:%M %p - %A")} has been canceled."
        #subject_msg_advisor = "Canceled:Your Appointment with #{full_name} on #{@event_mailer.start_date.strftime("%m/%d/%Y %I:%M %p - %A")} has been canceled."
        @body_msg =  "Your appointment with " + @event_mailer.description + " on " + @event_mailer.start_date.strftime("%m/%d/%Y %I:%M %p - %A") + " has been canceled.<br><br>" +
            "Student Name - #{full_name} (#{student_email})<br>" +
            "#{@event_mailer.description} (#{cc_email})<br><br>"
        @cal_body_msg = "Your appointment with " + @event_mailer.description + " on " + @event_mailer.start_date.strftime("%m/%d/%Y %I:%M %p - %A") + " has been canceled.\\n\\n" +
            "Student Name - #{full_name} (#{student_email})\\n" +
            "#{@event_mailer.description} (#{cc_email})\\n\\n"

        log_emails(emails, "Canceled Appointment: ", @event_mailer, subject_msg)
      end

       ical = Icalendar::Calendar.new
       e = Icalendar::Event.new
       e.dtstart = @event_mailer.start_date #DateTime.now.utc
       #e.start.icalendar_tzid="UTC" # set timezone as "UTC"
       e.dtend = @event_mailer.end_date #(DateTime.now + 1.day).utc
       #e.end.icalendar_tzid="UTC"
       e.organizer = student_email
       e.uid = "MeetingRequest#{meeting.id}"
       e.summary = subject_msg
       e.description = "Hello " + first_name + ",\n\n" + @cal_body_msg + SENDER_SIGN #{}"Testing icalendar!"
       ical.add_event(e)
       #ical.publish
       ical.to_ical
       attachments['calendar.ics'] = ical.to_ical
       if cc_email == 'harrisor@ohsu.edu'  and (File.file?(Rails.root + "public/oasis/im_advising_handbook.pdf")) ## only this advisor requires to send the IM advising handbook to students
         attachments['IM_Advising_Handbook.pdf'] = File.read(Rails.root + "public/oasis/im_advising_handbook.pdf")
       end
       # # send email to student
       # emails << student_email
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
      f.write("Emails sent on (mm/dd/yyyy) " + Time.now.strftime("%m/%d/%Y %H:%M") + "\n")
      f.write("Emails: " + to_emails.inspect + "\n")
      f.write("subject: " + subject_msg + "\n")
      f.write("===========================================================================\n")
    end
  end

end
