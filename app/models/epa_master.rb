class EpaMaster < ApplicationRecord
    #self.primary_key = [:user_id, :epa]
    belongs_to :user

    def statuses?
       if (self.status1.to_s + self.status2.to_s + self.status3.to_s).include? "Yes"
         return true
       else
         return false
       end
    end

end
