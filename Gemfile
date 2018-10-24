source "https://rubygems.org"

##############################
# Main
##############################
gem "bundler"
gem 'rails', '~> 5.2'
gem "rdoc"
gem 'whenever', require: false
gem 'nested_form_fields'
gem 'turbolinks', '~> 5.0', '>= 5.0.1'

# Database
gem "pg"
gem 'composite_primary_keys', '~> 11.0'
gem "redis"

# Record Versioning
gem "paper_trail"
# lime survey db interaction
gem "php-serialize"

##############################
# Admin/Config/Security
##############################
gem "rails_admin"

# Config file loader
# see ./lib/settings.rb and ./config/settings.yml for details
gem "settingslogic"

gem "cancancan"
gem "devise"
# LDAP
gem "devise_ldap_authenticatable"
# Prevent Excessive log file information
gem "lograge"

##############################
# JavaScript and CSS
##############################
gem 'sassc-rails'
gem "coffee-rails"
gem "uglifier"
gem "jquery-rails"
gem "jquery-ui-rails"

# CSS / js
gem "bootstrap-sass"
gem "select2-rails"

# pagination
gem 'kaminari'

##############################
# UI: Charts
##############################

gem "json"
gem "gon"

##############################
# UI: Forms
##############################

# Dynamic Forms
gem "cocoon"
gem "simple_form"

##############################
# UI: Misc
##############################

# Static Pages
gem "high_voltage"
# Statistics
gem "descriptive-statistics"

##############################
# Analysis
##############################

gem "statistics2"

##############################
# Environments
##############################

group :test, :development do
  gem "rspec-rails"
  gem "capybara"
  gem "rails-perftest"
  gem "factory_bot_rails"
  gem "faker"
  gem 'rails-controller-testing'
  gem "byebug"
  gem "better_errors"
  gem "stackprof"
  gem "ruby-prof"
  gem "pry"
end

group :production do
  # Send emails to admin when an error occurs
  gem "exception_notification"
end

# To use debugger
group :development do
  gem "rack-mini-profiler", require: false
  gem "webrick"
  gem "puma"
  gem "rails_layout"
  gem "awesome_print"

  # Interactive debugging from the web
  gem "binding_of_caller"
  gem "redcarpet"
  gem 'twitter-bootstrap-rails'

  # guard
  gem "guard"
end
