class UnexplainedVersion < ActiveRecord::Base
    self.table_name = 'versions'
    default_scope {where :version_note_id => nil}
    self.primary_key =  :id

    rails_admin do
        navigation_label 'Dataset Changes'
    end

end
