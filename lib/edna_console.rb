require 'edna_console/ar_extensions'
require 'edna_console/rails_admin'
require 'edna_console/dashboard_lib'

module EdnaConsole
    class Application < Rails::Application
        #config.after_initialize do
        #    # make sure all models have been loaded
        #    Rails.application.eager_load!

        #    # Add extensions to some models
        #    ::EdnaConsole::ArExtensions.load_extensions
        #    ::EdnaConsole::RailsAdmin.load_extensions
        #end
    end
end

