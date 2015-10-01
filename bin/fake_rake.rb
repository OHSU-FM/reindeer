#!/usr/bin/env ruby
# 
# 

require 'open3'
require 'optparse'

# Boot rails application so that we can access models etc...
require File.expand_path('../../config/boot',  __FILE__)
require File.expand_path('../../config/application',  __FILE__)
# set Rails.env here if desired
Rails.application.require_environment!

def usage
	p  "Usage: fake_rake [START] [STOP] [FLAGS]"
  	p  ""
  	p  "Positional arguments: (default to run all)"
  	p  "     start:		start migration #"
  	p  "     stop:		stop migration #"
  	p  ""
  	p  "Flags:"
  	p  "	--dir		Dir to search for"
end

psql_args = "-U #{ENV['DB_USERNAME']} -h #{ENV['DB_HOST']} #{ENV['DB_DATABASE']}"
search_dir = './db/data-migrations'	# Search for files to run in here
migration = nil
migration_stop = nil
skip = false
ARGV.each_with_index{|arg,idx|
	if skip
		skip=false
		next
	end

	if idx == 0 && !arg.start_with?('--')
		migration = arg
		next
	end
	
	if idx == 1 && !arg.start_with?('--')
		migration_stop = arg
		next
	end

	if arg=='--dir'
		search_dir = ARGV[idx+1] if ARGV.length >= idx+1
		skip = true
	end
}

files =  Dir.glob( File.join(search_dir,'[0-9]*.{sql,rb,sh}')).sort!
puts search_dir
nothing_to_run = true

for file in files

	# Get number for current migration
    m_number = File.basename(file).match('^\d+')[0]
	
	# Should we stop? 
    if not migration_stop.nil?
        if migration_stop.to_i < m_number.to_i
			# Yes
            puts "Done with migration range"
            exit
        elsif migration.to_i > m_number.to_i
			
            next
            
        end
    end

    file = File.expand_path( file )
	

    if migration and m_number != migration and migration_stop.nil?
        next
    end

    nothing_to_run = false

    puts "Running.... #{File.basename(file,'.*')}"

    if file.match('.rb$')
        require file.chomp(File.extname(file))
        next
    elsif file.match('.sql$')
        cmd = "psql #{psql_args} -v ON_ERROR_STOP=1  -f #{file}"
    elsif file.match('.sh$')
        cmd = "bash #{file}"
    else
        puts "Skipping #{File.basename(file)}"
        next
    end
    puts cmd
    puts %x{ #{cmd} }

    if $?.exitstatus != 0
        puts %x{ #{cmd} }
        puts "Error"
        exit
    end

end

# Show error
if nothing_to_run
    puts  'Error: Nothing to run'
end
