module Coaching::MeetingsHelper
  require 'mail'

  def hf_send_email(curr_user, data)
    sender = curr_user.email
    subject =  data['message']
    discussable_id = Room.find(data['roomNumber']).discussable_id
    to_email = User.find(Coaching::Meeting.find(discussable_id).user_id).email

    options = { :address          => "smtp.ohsu.edu",
            :port                 => 25,
            :domain               => 'redei-som.ohsu.edu',
            :authentication       => 'plain',
            :enable_starttls_auto => true  }



    Mail.defaults do
      delivery_method :smtp, options
    end

    mail = Mail.new do
      mail.from = sender
      mail.to = 'chungp@ohsu.edu'
      mail.subject = subject
      mail.body = "THIS IS A TEST!"
    end

   mail.deliver!

  end



end
