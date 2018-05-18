class Settings < Settingslogic
  source "#{Rails.root}/config/settings.yml"
  namespace Rails.env
end

class Threshold < Settingslogic
    source "#{Rails.root}/config/threshold.yml"
    namespace Rails.env
end
