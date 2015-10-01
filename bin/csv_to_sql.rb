#!/usr/bin/env ruby

require 'csv'
require 'cgi'

require 'rubygems'
#require 'ruby-debug'

def usage
    puts 'Usage:'
    puts '  csv_to_sql.rb [no_transaction] tablename csvfile [tablename csvfile ...]'
    exit 1
end

# Convert csv file to sql syntax and output to STDOUT
def convert_csv(path,table_name, in_transaction)
    
    # csv file has a header row
    header_row = true

    # delimiter for csv file
    delimiter = ','

    # variable used to skip header row
    skip_row = true

    # keep columns
    keep_cols = []

    # skip a column if it is prefixed with this
    skip_prefix = '-'

    # Create a sub-select statement if this character exists in header
    sub_select_char = '~'

    # Place sql statement in a transaction
    puts 'BEGIN TRANSACTION;' if in_transaction == true

    ## For ruby 1.9.3
    CSV.foreach(path) do |row|
    ## For REE (1.8.7)
    #CSV.open(path, 'r', delimiter ) do |row|

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
            # yes we are

            # for each column
            row.each_with_index do |col,index|
                # remove quotes and whitespace
                col = col.gsub("'",'').strip
                # put column name in quotes (required because some columns *webads* have
                #   periods in the column name
                row[index] = "\"#{col}\""
                
                # skip if start with skip_prefix
                if col.start_with?(skip_prefix) || col=='NULL'
                    next
                end
                    
                # add to list to keep
                keep_cols.push(index)
            end
            header_row = false
            print "INSERT INTO \n    #{table_name} (#{row.values_at(*keep_cols).join delimiter }) \nVALUES\n"
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
        print "    (#{row.values_at(*keep_cols).join delimiter})"
        
    end
    puts ';'
    puts 'COMMIT;' if in_transaction == true
end


transaction = true

# Check for transaction option and remove it from the arg stack if present
if ARGV.size > 0 && ARGV.include?('no_transaction')
    ARGV.shift
    transaction = false
end

# require correct parameters
if ARGV.size < 2
    usage
    puts 'Error: Must have an even number of parameters'
end

# multiple sets of files/tables can be included in the same transaction, but they each need a table=>file 
if ARGV.size % 2 !=0
    usage
    puts 'Error: Must have an even number of parameters'
end

# Run commands
(0..ARGV.size-1).step(2){|i|
    convert_csv ARGV[i+1], ARGV[i], transaction
}

