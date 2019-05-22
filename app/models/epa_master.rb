class EpaMaster < ApplicationRecord
    #self.primary_key = [:user_id, :epa]
    belongs_to :user
    has_many   :epa_reviews, as: :reviewable,  dependent: :destroy
    accepts_nested_attributes_for :epa_reviews

    def statuses?
       if (self.status == "Badge")
         return true
       else
         return false
       end
    end

    def self.export_data_delimited permission_group_id
      users = User.where(permission_group_id: permission_group_id)
      file_ptr = File.open(Rails.root + "tmp/chungp_epas.txt", 'w')

      users.each do |user|
        file_ptr.write(user.id.to_s + "|" + user.full_name.to_s + "|")
        user.epa_masters.each do |epa|
          file_ptr.write(epa.status.to_s + "|")
        end
        file_ptr.write("")
      end
      file_ptr.close

    end

end
