#require 'rake/testtask'

namespace :db do
  namespace :test do
    desc 'Load sample lime survey schema before migrations'
    task :before do
      base_schema = './test/base_lime_schema.rb'
      configuration = ActiveRecord::Base.configurations['test']
      ActiveRecord::Tasks::DatabaseTasks.load_schema_for configuration, :ruby, base_schema
    end
  end
end

if Rails.env.test? || Rake.application.top_level_tasks.include?('db:test:prepare')
  Rake::Task['db:test:load_schema'].enhance ['db:test:before']
end
