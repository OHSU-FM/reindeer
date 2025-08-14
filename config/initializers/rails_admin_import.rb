RailsAdmin.config do |config|
  # REQUIRED:
  # Include the import action
  # See https://github.com/sferik/rails_admin/wiki/Actions
  config.actions do
    all
    import
  end

  # Optional:
  # Configure global RailsAdminImport options
  # Configure pass filename to records hashes
  config.configure_with(:import) do |config|
    config.logging = true
    config.pass_filename = true
  end

  # Optional:
  # Configure model-specific options using standard RailsAdmin DSL
  # See https://github.com/sferik/rails_admin/wiki/Railsadmin-DSL
  config.model 'Med26Mspe' do
    import do
      include_all_fields
    end
  end
end
