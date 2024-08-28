class Event < ApplicationRecord

  belongs_to :advisor, optional: true
  belongs_to :user, inverse_of: :events, optional: true

  #WillPaginate.per_page = 10
  def self.reformat_startDate(start_date_hash, recur_hash, time_slot, count)
    date_hash = {}
    i = 1
    for c in 1..count
      no_of_weeks = recur_hash["weekly_recurrences#{c}"]
      start_date = start_date_hash["rstartDate#{c}"]

      if start_date.to_s != "" and no_of_weeks.to_i != 0
        for w in 0..no_of_weeks.to_i
           date_hash.store("Date #{i}", (start_date.to_datetime + w.weeks).utc.strftime("%m/%d/%Y %T %p"))
           i += 1
        end
      else
        date_hash.store("Date #{i}", start_date.to_datetime.utc.strftime("%m/%d/%Y %T %p")) if start_date.to_s != ""
        i += 1
      end
    end
    return date_hash
  end

  def self.process_weekly_recurrences(date_array, weekly_recurrences)
    date_hash = {}
    i = 1
    date_array.values.each do |date|
      for w in 0..weekly_recurrences.to_i
        date_hash.store("Date #{i}", (date.to_datetime + w.weeks).utc.strftime("%m/%d/%Y %T %p"))
        i += 1
      end
    end

    return date_hash

  end

  def self.enumerate_hours2(start_date, end_date, time_slot, advisor_type, weekly_recurrences)
    if start_date.nil?
      return nil
    end
    date_array = {}
    i = 1
    if advisor_type == 'Assist Dean'
      time_slot = time_slot.to_i
    else
      time_slot = time_slot.to_i + 15
    end
    # if time_slot.to_i == 30
    #   time_slot = time_slot.to_i + 15
    # end

    # time_slot = time_slot.to_i

    (start_date.to_s.to_datetime.utc.to_i .. end_date.to_s.to_datetime.utc.to_i).step(time_slot*60) do |date|
       date_array.store("Date #{i}", Time.at(date).utc.strftime("%Y/%m/%d %T %p"))
       #puts "time: "  + Time.at(date).utc.strftime("%m/%d/%Y %T %p")
       i = i + 1
    end
    if weekly_recurrences.to_i != 0
      date_array_recurrences = process_weekly_recurrences(date_array, weekly_recurrences)
      return date_array_recurrences
    else
      return date_array
    end
  end

  def self.enumerate_hours(start_date, end_date, time_slot, advisor_type, weekly_recurrences)
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
       date_array.store("Date #{i}", Time.at(date).utc.strftime("%Y/%m/%d %T %p"))
       #puts "time: "  + Time.at(date).utc.strftime("%m/%d/%Y %T %p")
       i = i + 1
    end
    if weekly_recurrences.to_i != 0
      date_array_recurrences = process_weekly_recurrences(date_array, weekly_recurrences)
      return date_array_recurrences
    else
      return date_array
    end

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
