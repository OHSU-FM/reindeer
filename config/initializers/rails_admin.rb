
require './lib/rails_admin/config/actions/refresh'

showable_models = ['Chart', 'Dashboard']

RailsAdmin.config do |config|
  config.actions do
    dashboard do
        statistics false
    end
    # Collection Actions
    index
    history_index
    export
    bulk_delete

    # Member Actions
    new
    edit
    show
    delete
    refresh

    history_show
    #history_show do
    #    visible do
    #        bindings[:abstract_model].model.to_s != 'User'
    #    end
    #end
    show_in_app do
        visible do
            showable_models.include? bindings[:abstract_model].model.to_s
        end
    end

  end

  config.model 'Event' do
    edit do
      field :title
      field :description
      # Config date's format
      field :start_date do
        strftime_format '%d-%m-%Y %H:%M:%S'
      end
      field :end_date do
        strftime_format '%d-%m-%Y %H:%M:%S'
      end
    end
  end

  # Temporary workaround for bug in rails_admin, forms won't submit
  #https://github.com/sferik/rails_admin/issues/2443
  config.browser_validations = false
  config.total_columns_width = 1200
  ################  Global configuration  ################

  # Set the admin name here (optional second array element will appear in red). For example:
  #config.main_app_name = ['EdnaConsole', 'Admin']
  # or for a more dynamic name:
  # config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }
  config.main_app_name = [Settings.site.name, 'Admin']

  # RailsAdmin may need a way to know who the current user is]
  config.current_user_method { current_user } # auto-generated

  config.authorize_with :cancancan

  # If you want to track changes on your models:
  # config.audit_with :history, 'User'

  # Or with a PaperTrail: (you need to install it first)
  #config.audit_with :paper_trail, 'User'

  # Display empty fields in show views:
  config.compact_show_view = false

  # Number of default rows per-page:
  config.default_items_per_page = 50

  # Exclude specific models (keep the others):
  #config.excluded_models = Dir.glob(Rails.root.join('app/models/concerns/**.rb')).map {|p| 'Concerns::' + File.basename(p, '.rb').camelize }
  config.excluded_models << %w'Mini-profiler-resources DataMaker DashboardLib ArExtensions DashboardWidget'

  # Include specific models (exclude the others):
  #config.included_models << %w'LimeExt::DbRule'
  #  MetaAttribute::MetaAttributeQuestion MetaAttribute::MetaAttributeEntityGroup
  #  P4Resident P4Program DashboardWidget Dashboard ContentSlug MetaAttribute::MetaAttributeValue MetaAttribute::MetaAttributeStatistic'

  # Label methods for model instances:
  #config.label_methods << :description # Default is [:name, :title]

  ################  Model configuration  ################
  #config.model 'LimeExt::SyncTrigger' do
  #    navigation_label "Lime Survey"
  #end

end
