# Load the Rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Rails.application.initialize!

# Prevent legacy application tables and lime_survey tables
# from being checked into schema.rb
ActiveRecord::SchemaDumper.ignore_tables = [
  /^y\d_/,
  /p4_/,
  /^#{LimeExt.table_prefix}/
]

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html_tag.html_safe
end
