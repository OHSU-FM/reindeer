#!/usr/bin/env ruby

require 'csv'
require 'cgi'

def usage
    puts 'Usage:'
    puts '  csv_to_sql.rb tablename csvfile [tablename csvfile ...]'
    exit 1
end

# Convert csv file to sql syntax and output to STDOUT
def convert_csv(path, table_name)
    
    # csv file has a header row
    header_row = true

    # delimiter for csv file
    delimiter = ','

    # variable used to skip header row
    skip_row = true


    CSV.open(path, 'r', delimiter ) do |row|

        row.each_with_index do |col,index|
            if col==nil then 
                row[index]='NULL'
            else
                
                col.gsub!("'","`")
                row[index] = "'#{ col }'"
            end
        end

        # Are we reading the header row of the csv file?
        if header_row
            row.each_with_index do |col,index|
                row[index] = "\"#{ col.gsub("'",'').gsub(/\s+/,'') }\""
            end
            header_row = false
            print "INSERT INTO #{table_name} (#{row.join delimiter }) VALUES"
            next
        end

        # Only skip the first (header) row
        if skip_row == true
            # dont skip further rows
            skip_row = false
        else
            # Print end of line insert delimeter
            puts delimiter
        end
        
        # Print to stdout
        print "(#{row.join delimiter})"
        
    end
end

# require correct parameters
if ARGV.size < 2
    usage
end

# multiple sets of files/tables can be included in the same transaction, but they each need a table=>file 
if ARGV.size % 2 !=0
    puts 'Error: Must have an even number of parameters'
    usage
end

# Run commands
(0..ARGV.size-1).step(2){|i|
    convert_csv ARGV[i+1], ARGV[i]
}

