class Settings < Settingslogic
    source "#{Rails.root}/config/settings.yml"
    namespace Rails.env

    def self.assignments_route_name
      self.try{ |s|
        name = site.titles.assignment_group.pluralize.downcase
        name.gsub(' ','_')
      } || 'goals'
    end
    
    def self.user_assignments_route_name
      self.try{ |s|
        name = site.titles.user_assignment.pluralize.downcase
        name.gsub(' ','_')
      } || 'action_plans'
    end

end
