#require 'rake/testtask'

namespace :db do
  namespace :test do
    desc 'Load sample lime survey schema before migrations'
    task :before do
      raise 'Only in test environment' unless Rails.env.test?
      base_schema = './test/base_lime_schema.rb'
      ActiveRecord::Tasks::DatabaseTasks.load_schema_current(:ruby, base_schema)
    end
  end
end

if Rails.env.test?
  Rake::Task['db:schema:load'].enhance ['db:test:before']
end
