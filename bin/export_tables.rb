#!/usr/bin/env ruby

# Boot rails application so that we can access models etc...
require File.expand_path('../../config/boot',  __FILE__)
require File.expand_path('../../config/application',  __FILE__)
# set Rails.env here if desired
Rails.application.require_environment!

# Create temp directory 
time_stamp = Time.now.strftime('%Y%m%d%H%M%S')
tmp_path = "./tmp/table_dumps_#{time_stamp}"
FileUtils::mkdir_p tmp_path

# Get config
config   = Rails.configuration.database_configuration
database = config[Rails.env]["database"]
username = config[Rails.env]["username"]
get_data = true
then_drop = false

if ARGV.include? '--no-data'
    get_data = false
end
binding.pry
tables = ActiveRecord::Base.connection.tables.to_a

if ARGV.include? '--lime-only'
  tables = tables.select{|table|table.start_with? LimeExt.table_prefix}
end

if ARGV.include? '--then-drop'
  then_drop = true
end

# Dump tables
tables.each do |table|
    connect_str = "-h localhost -U #{username} #{database}"

    system "pg_dump #{connect_str} #{ '-s' unless get_data } -t '*.#{table}' -f #{tmp_path}/#{table}.dump.sql"
    
    if then_drop
      puts "psql #{connect_str} -c 'DROP TABLE IF EXISTS #{table} CASCADE;'" 
      system "psql #{connect_str} -c 'DROP TABLE IF EXISTS #{table} CASCADE;'"
    end
end
