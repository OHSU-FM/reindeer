class ContentSlug < ActiveRecord::Base
  has_one :dash_widget, class_name: 'DashboardWidget', as: :widget
  rails_admin do
    navigation_label 'User Content'
  end
end
