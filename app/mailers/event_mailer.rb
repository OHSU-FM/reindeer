class EventMailer < ApplicationMailer
  def notify_student (meeting)

      @event_mailer = Event.find_by(id: meeting.event_id)
      @meeting_mailer = meeting
      student_email = meeting.user.email # student email
      cc = Advisor.find_by(id: meeting.advisor_id).email  # advisor email
      mail(to: 'chungp@ohsu.edu', subject: "New Appointment with #{@event_mailer.description} on #{@event_mailer.start_date.strftime("%m/%d/%Y %I:%M %p - %A")}")
  end
end
