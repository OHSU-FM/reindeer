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


end
