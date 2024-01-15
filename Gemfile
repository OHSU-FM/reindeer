source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }
##############################
# Main
##############################
gem "bundler", '~>2.0'
gem 'rails'  #, '~>6.1.3' #'~> 5.2.2.1'
gem "rdoc", '~>6.3.1'
gem "psych", '< 4'
gem 'sprockets', '< 4'
gem 'bcrypt'
# Database
#gem 'pg', '~> 1.3', '>= 1.3.4'
gem 'pg'
#gem "composite_primary_keys"
# commented redis server out on 3/11/2022
# To disable ActionCable
gem "redis", "~>4.1.0"
#==============================
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
#gem "devise", "~> 4.6.2"
gem 'devise', '~> 4.7', '>= 4.7.3'
# LDAP
gem "devise_ldap_authenticatable"
# Prevent Excessive log file information
gem "lograge"

##############################
# JavaScript and CSS
##############################
gem 'bootstrap'#, '~> 4.4.0'
gem "jbuilder", '~> 2.5'
gem "popper_js", "~> 1.14.3"
#gem "bootstrap-sass"   #, '~> 3.4.1'
gem "sass-rails", '>= 3.2'
gem "coffee-rails"
gem "uglifier"
gem 'jquery-ui-rails'
gem "jquery-rails"
gem "jquery_context_menu-rails"
gem "momentjs-rails"
gem "fullcalendar-rails"
gem "fullcalendar"
#gem 'webpacker', '~> 3.5'
# CSS / js
# Random bug:
# Error encountered while saving cache (".....") can't dump anonymous class
# http://stackoverflow.com/questions/22276991/heroku-error-encountered-while-saving-cache
gem "sass"#, "~> 3.2.13"
gem "select2-rails"

# pagination
gem 'kaminari'

##############################
# UI: Charts
##############################

gem 'json', '~> 2.5', '>= 2.5.1'
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
  gem 'letter_opener'
end

group :test, :development do
  if RUBY_VERSION =~ /^1.9.3/
    # Better error messages in development
    gem "better_errors", "~> 1.1"
  elsif RUBY_VERSION =~ /^3./
    gem "byebug"
    gem "better_errors"
    # gem "stackprof"
    # gem "ruby-prof"
    # gem "pry"
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
  gem "puma", "~> 6.3.1"
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
gem 'mini_racer'
gem 'autoprefixer-rails'
gem 'rufus-scheduler'    # gem "stackprof"
    # gem "ruby-prof"
    # gem "pry"
gem 'whenever', require: false
gem 'nested_form_fields'
#gem 'turbolinks', '~> 5.0', '>= 5.0.1'
gem 'rails-ujs', '~> 0.1.0'
# highchart
gem "highcharts-rails"
gem "lazy_high_charts"
#gem 'chartkick'
#gem 'groupdate'
#=======================
# dataTables
gem 'jquery-datatables'
#========================
gem "csv_hasher"
gem 'activestorage-validator', '~> 0.1.0'
gem 'bullet', group: 'development'
gem 'font-awesome-sass', '~> 4.4.0'
gem "font-awesome-rails"
gem 'will_paginate', '~> 3.1'
gem 'datejs-rails', "~> 2.0.1"
gem 'icalendar'
gem 'sassc-rails'
gem 'xsv'
gem 'fast_page'
gem 'aes'
gem 'active_storage_drag_and_drop'
gem 'image_processing'
