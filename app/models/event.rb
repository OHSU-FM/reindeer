class Event < ApplicationRecord

  #belongs_to :meeting

  WillPaginate.per_page = 10


  def self.enumerate_hours(start_date, end_date)
    date_array = {}
    i = 1
    (start_date.to_datetime.utc.to_i .. end_date.to_datetime.utc.to_i).step(1.hour) do |date|
       date_array.store("Date #{i}", Time.at(date).utc.strftime("%m/%d/%Y %T %p"))
       puts "time: "  + Time.at(date).utc.strftime("%m/%d/%Y %T %p")
       i = i + 1
    end

    return date_array

  end
end
