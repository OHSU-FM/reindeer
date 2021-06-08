class EventMailer < ApplicationMailer
  def notify_student (meeting)
      @event_mailer = Event.find(meeting.event_id)
      @meeting_mailer = meeting
      student_email = meeting.user.email # student email
      cc_email = Advisor.find_by(id: meeting.advisor_id).email  # advisor email
      emails = []
      emails << student_email
      emails << cc_email

      # cal = Icalendar::Calendar.new
      # e = Icalendar::Event.new
      # e.dtstart     = Icalendar::Values::DateTime.new(@event_mailer.start_date)
      # e.dtend       = Icalendar::Values::DateTime.new(@event_mailer.end_date)
      # e.summary     = @event_mailer.description
      # e.description = @event_mailer..description
      # e.url         = "https://redei.ohsu.edu"
      # cal.add_event(e)
      # cal.publish
      # attachments["event.ics"] = { mime_type: 'application/ics', content: cal.to_ical }
      #
      # emails = ["chungp@ohsu.edu"]
      
      mail(to: emails, from: "chomina@ohsu.edu", subject: "New Appointment with #{@event_mailer.description} on #{@event_mailer.start_date.strftime("%m/%d/%Y %I:%M %p - %A")}")

  end
end
