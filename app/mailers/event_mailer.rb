class EventMailer < ApplicationMailer
  def notify_student (meeting)
      @event_mailer = Event.find(meeting.event_id)
      @meeting_mailer = meeting
      student_email = meeting.user.email # student email
      cc_email = Advisor.find_by(id: meeting.advisor_id).email  # advisor email
      emails = []
      #emails << student_email
      #emails << cc_email
      @cal = AddToCalendar::URLs.new(
            start_datetime: @event_mailer.start_date,
            end_datetime: @event_mailer.end_date,
            title: "Meeting with student, #{meeting.user.full_name}",
            timezone: 'America/Los_Angeles'
          )
      emails = ["chungp@ohsu.edu"]
      mail(to: emails, from: "chomina@ohsu.edu", subject: "New Appointment with #{@event_mailer.description} on #{@event_mailer.start_date.strftime("%m/%d/%Y %I:%M %p - %A")}")

  end
end
