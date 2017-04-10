# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
#
#
every '28 07 * * *' do
    command "/home/patrick/.rvm/rubies/ruby-2.2.2/bin/ruby /home/patrick/source/reindeer/tmp/api_core_exp_electives.rb  > /home/patrick/source/reindeer/tmp/api_medhub.log 2>&1"
end


