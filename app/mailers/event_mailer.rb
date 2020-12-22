class EventMailer < ApplicationMailer
  def notify_student
        mail(to: 'chungp@ohsu.edu', subject: 'Welcome!')
  end
end
