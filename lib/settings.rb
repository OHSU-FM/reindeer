class Settings < Settingslogic
  source "#{Rails.root}/config/settings.yml"
  namespace Rails.env

  def self.assignments_route_name
    name = site.titles.assignment_group.pluralize.downcase.gsub(' ','_')
  rescue
    'goals'
  end
end
