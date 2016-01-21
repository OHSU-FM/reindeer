class LimeUser < ActiveRecord::Base
    self.inheritance_column = nil
    self.primary_key = :uid

    rails_admin do
        navigation_label "Lime Survey"
    end

    def title
        email
    end
end

