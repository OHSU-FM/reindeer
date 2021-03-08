class Event < ApplicationRecord

  belongs_to :advisor
  belongs_to :user, inverse_of: :events

  #WillPaginate.per_page = 10


  def self.enumerate_hours(start_date, end_date, time_slot)

    if start_date.nil?
      return nil
    end

    date_array = {}
    i = 1

    start_date =  start_date["start_date(1i)"] + "-" +
                  start_date["start_date(2i)"] + "-" +
                  start_date["start_date(3i)"] + " " +
                  start_date["start_date(4i)"] + ":" +
                  start_date["start_date(5i)"]
    end_date =  end_date["end_date(1i)"] + "-" +
                  end_date["end_date(2i)"] + "-" +
                  end_date["end_date(3i)"] + " " +
                  end_date["end_date(4i)"] + ":" +
                  end_date["end_date(5i)"]


    (start_date.to_s.to_datetime.utc.to_i .. end_date.to_s.to_datetime.utc.to_i).step(time_slot.to_i*60) do |date|
       date_array.store("Date #{i}", Time.at(date).utc.strftime("%m/%d/%Y %T %p"))
       #puts "time: "  + Time.at(date).utc.strftime("%m/%d/%Y %T %p")
       i = i + 1
    end

    return date_array

  end
end
