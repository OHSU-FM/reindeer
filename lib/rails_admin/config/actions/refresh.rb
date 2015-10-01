require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class Refresh < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)
        
        # This will be visible in the list section
        
        register_instance_option :member do
            true
        end
         
        register_instance_option :controller do
            Proc.new do
                # Call refresh
                msg = @object.refresh
                if not msg
                    # Send notice when action is complete
                    flash[:notice] = "Refresh complete"
                else
                    msg.each do |key, val|
                        flash[key] = val
                    end
                end
                redirect_to back_or_index
            end          
        end
       
        # Only show the refresh option if the model responds to the refresh method
        register_instance_option :visible? do
            authorized? && bindings[:object].respond_to?('refresh') && bindings[:object].can_refresh? 
        end
        
        # Set icon for action
        register_instance_option :link_icon do
          'icon-retweet'
        end
        
        # disable pjax
        register_instance_option :pjax? do
          false
        end
      end
    end
  end
end
