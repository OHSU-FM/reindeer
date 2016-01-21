class ContentSlug < ActiveRecord::Base
    attr_accessible :content, :public
    has_one :dash_widget, :class_name=>'DashboardWidget', :as=>:widget
    rails_admin do
        navigation_label 'User Content'

    end
end
