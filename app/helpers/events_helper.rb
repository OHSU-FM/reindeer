module EventsHelper

  def format_date_yyyymmdd(in_date)
    # in_date format mm/dd/yyyy
    temp_date = in_date.split("/")
    return temp_date[2] + "/" + temp_date[0] + "/" + temp_date[1]
  end

  def hf_format_datetime(in_datetime)
    temp_datetime = in_datetime.split(" ")
    formatted_date = format_date_yyyymmdd(temp_datetime[0])

    return formatted_date + " " + temp_datetime[1] + " " + temp_datetime[2]

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


end
