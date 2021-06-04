class EventMailer < ApplicationMailer
  def notify_student (meeting)
      @event_mailer = Event.find(meeting.event_id)
      @meeting_mailer = meeting
      student_email = meeting.user.email # student email
      cc_email = Advisor.find_by(id: meeting.advisor_id).email  # advisor email
      emails = []
      emails << student_email
      emails << cc_email
      # emails = ["chungp@ohsu.edu"]
      #
      # cal = Icalendar::Calendar.new
      # filename = "cal"
      # if params[:format] == 'vcs'
      #   cal.prodid = '-//Microsoft Corporation//Outlook MIMEDIR//EN'
      #   cal.version = '1.0'
      #   filename += '.vcs'
      # else # ical
      #   cal.prodid = '-//Acme Widgets, Inc.//NONSGML ExportToCalendar//EN'
      #   cal.version = '2.0'
      #   filename += '.ics'
      # end
      #
      # cal.event do |e|
      #   e.dtstart     = Icalendar::Values::DateTime.new(@event_mailer.start_date)
      #   e.dtend       = Icalendar::Values::DateTime.new(@event_mailer.end_date)
      #   e.summary     = @event_mailer.description
      #   e.description = @event_mailer..description
      #   e.url         = "https://redei.ohsu.edu"
      #   e.location    = "Via WebEx"
      # end
      # send_data cal.to_ical, type: 'text/calendar', disposition: 'attachment', filename: filename
      mail(to: emails, from: "chomina@ohsu.edu", subject: "New Appointment with #{@event_mailer.description} on #{@event_mailer.start_date.strftime("%m/%d/%Y %I:%M %p - %A")}")

  end
end
