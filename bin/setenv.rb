#!/usr/bin/env ruby


# Output environment variables
require "rubygems"
require 'yaml'

# Load config data from rails
conf_path = File.join( File.dirname(File.dirname(__FILE__)) , './config/database.yml'  )
#p "Reading config information from: #{conf_path}"
dbconfig = YAML::load(File.open(conf_path))[ENV['RAILS_ENV'] || 'development']
puts "#!/usr/bin/env bash"
dbconfig.each {|k,v|
	puts "export DB_#{k.upcase}=\"#{v}\""
}
puts "export PGPASSWORD=$DB_PASSWORD"
