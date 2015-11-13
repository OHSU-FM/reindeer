class Settings < Settingslogic
    source "#{Rails.root}/config/settings.yml"
    namespace Rails.env

    def self.assignments_route_name
      name = site.titles.assignment_group.pluralize.downcase.gsub(' ','_')
    rescue
      'goals'
    end
    
    def self.user_assignments_route_name
      site.titles.user_assignment.pluralize.downcase.gsub(' ','_')
    rescue
      'action_plans'
    end

end
