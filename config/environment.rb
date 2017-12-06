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
