require 'rake/testtask'

#namespace :db do
#  namespace :sql_seed do
#    raise 'only in test' unless Rails.env == 'test'
#    conf = Rails.configuration.database_configuration[Rails.env]
#    system({'PGPASSWORD'=>conf['password']},
#      "psql -U #{conf['username']} #{conf['database']} -f ./tmp/latest.sql")
#  end
#end
