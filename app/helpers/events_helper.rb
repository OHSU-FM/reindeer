module EventsHelper

  def hf_get_advisors advisor_type
    @advisors = Advisor.where(advisor_type: advisor_type)

    return @advisors.map{|a| [a.name, a.id]}
  end

  def format_date_yyyymmdd(in_date)
    # in_date format mm/dd/yyyy
    temp_date = in_date.split("/")
    return temp_date[2] + "/" + temp_date[0] + "/" + temp_date[1]
  end

  def hf_format_datetime(in_datetime)
    temp_datetime = in_datetime.split(" ")
    formatted_date = format_date_yyyymmdd(temp_datetime[0])

    return formatted_date + " " + temp_datetime[1]  # + " " + temp_datetime[2]

  end

  def hf_full_name event_id
    meeting = Coaching::Meeting.find_by(event_id: event_id)
    if meeting.nil?
      return ""
    else
      user = User.find_by(id: meeting.user_id)
      return user.full_name
    end

  end

  def hf_get_date_now
    #DateTime.current.strftime("%m/%d/%Y %T %p")
    now = Time.now
    if now.min > 0 then
       now =  now + 3600
    end

    return now.strftime("%m/%d/%Y %T %p")

  end


end
