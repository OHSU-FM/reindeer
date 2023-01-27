class Event < ApplicationRecord

  belongs_to :advisor
  belongs_to :user, inverse_of: :events

  #WillPaginate.per_page = 10
  def self.reformat_startDate(startDates, time_slot)
    i = 1
    date_hash = {}
    startDates.each do |startDate|
      if startDate != ""
        date_hash.store("Date #{i}", startDate.to_datetime.utc.strftime("%m/%d/%Y %T %p"))
        i = i + 1
      end
    end
    return date_hash
  end

  def self.enumerate_hours(start_date, end_date, time_slot, advisor_type)
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
    if advisor_type == 'Assist Dean'
      time_slot = time_slot.to_i
    else
      time_slot = time_slot.to_i + 15
    end

    (start_date.to_s.to_datetime.utc.to_i .. end_date.to_s.to_datetime.utc.to_i).step(time_slot*60) do |date|
       date_array.store("Date #{i}", Time.at(date).utc.strftime("%m/%d/%Y %T %p"))
       #puts "time: "  + Time.at(date).utc.strftime("%m/%d/%Y %T %p")
       i = i + 1
    end

    return date_array

  end

  def self.fix_event_records
    events = Event.where("user_id is not null and advisor_id is null")
    events.each do |event|
      meeting = Coaching::Meeting.find_by(event_id: event.id, user_id: event.user_id)
      if !meeting.nil?
        event.update(advisor_id: meeting.advisor_id)
      end 
    end
  end
end
