source "https://rubygems.org"

##############################
# Main
##############################
gem "bundler"
gem 'rails', '5.0.0.1'
gem "rdoc"

# Database
gem "pg"
gem "composite_primary_keys"
gem "redis", "~>3.2"

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

gem "sass-rails"
gem "coffee-rails"
gem "uglifier"

gem "jquery-rails"
gem "jquery-ui-rails"

# CSS / js
gem "bootstrap-sass"
# Random bug:
# Error encountered while saving cache (".....") can't dump anonymous class
# http://stackoverflow.com/questions/22276991/heroku-error-encountered-while-saving-cache
gem "sass"#, "~> 3.2.13"
gem "select2-rails"

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

gem "smart_listing"

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
end

group :test, :development do
  if RUBY_VERSION =~ /^1.9.3/
    # Better error messages in development
    gem "better_errors", "~> 1.1"
  elsif RUBY_VERSION =~ /^2./
    gem "byebug"
    gem "better_errors"
    gem "stackprof"
    gem "ruby-prof"
  end
end

group :production do
  # Send emails to admin when an error occurs
  gem "exception_notification"
end

# To use debugger
group :development do
  gem "rack-mini-profiler", require: false
  gem "webrick"
  gem "thin"
  gem "rails_layout"
  gem "awesome_print"

  # Interactive debugging from the web
  gem "binding_of_caller"
  gem "redcarpet"
  gem "twitter-bootstrap-rails"

  # guard
  gem "guard"
  gem "guard-rspec"
end

gem 'rufus-scheduler'
gem 'whenever', :require => false
