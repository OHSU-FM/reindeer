Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Filter log file
  config.lograge.enabled = true
  # Reload files in the lib directory
  config.autoload_paths += %W(#{config.root}/lib/edna_console)

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and enable caching for reports controller
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = ENV['RAILS_CACHE'].to_s == '1'
  config.action_controller.include_all_helpers = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  #config.assets.compress = true
  #config.assets.compile = true
  #config.assets.digest = false
  config.assets.debug = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
  BetterErrors::Middleware.allow_ip! '127.0.0.1'
  
  # Enable this (as false) in order to see the error pages in a dev environment 
  #config.consider_all_requests_local = false
   # config.after_initialize do
   #   Bullet.enable = true
   #   Bullet.alert = true
   #   Bullet.bullet_logger = true
   #   Bullet.console = true
   #   #Bullet.growl = true
   #   Bullet.rails_logger = true
   #   #Bullet.rollbar = true
   #   Bullet.add_footer = true
   # end
  config.action_cable.disable_request_forgery_protection = true
  config.action_cable.allowed_request_origins = [/http:\/\/*/, /https:\/\/*/]
  config.action_cable.url = "ws://localhost:3000/cable"

end
