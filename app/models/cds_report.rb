class CdsReport < ApplicationRecord

  def self.get_total_active_goals cohorts
    return  hf_total_active_goals(cohorts)
  end
end
