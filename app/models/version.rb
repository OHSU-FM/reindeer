class Version < ActiveRecord::Base
    self.table_name = :versions
    belongs_to :version_note

    rails_admin do
        navigation_label 'Dataset Changes'
    end


    def name
        "#{item_type}:#{item_id}:#{event}"
    end

end
