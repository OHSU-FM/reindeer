#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

EdnaConsole::Application.load_tasks
Rake::Task['doc:app'].clear
RDoc::Task.new 'doc:app' do |rdoc|
  rdoc.rdoc_dir = 'doc/app'
  rdoc.template = ENV['template'] if ENV['template']
  rdoc.title    = ENV['title'] || "Rails Application Documentation"
  rdoc.options << '--line-numbers'
  rdoc.options << '--charset' << 'utf-8'
  rdoc.main = 'doc/guides'
  rdoc.rdoc_files.include('README.rdoc', 'app/**/*.rb', 'lib/**/*.rb', 'doc/*.rdoc', 'doc/*.md')
end
Rake::Task['doc:app'].comment = "Customized doc generation task"

