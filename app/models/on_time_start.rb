class OnTimeStart < ActiveRecord::Base
  def self.attribute_names
    {
      "id"=>"id",
      "Provider"=>"provider",
      "Site"=>"site",
      "Total First Cases"=>"total_first_cases",
      "Late Starts"=>"late_starts",
      "On Time Starts"=>"on_time_starts",
      "% On Time"=>"pct_on_time"
    }
  end
end
