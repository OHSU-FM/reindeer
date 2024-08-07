Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Reload files in the lib directory
  config.autoload_paths += %W(#{config.root}/lib/edna_console)

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = true

  # Should we eager load code on boot?
  config.eager_load = true

  # Show full error reports and enable caching for reports controller
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true

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
end
