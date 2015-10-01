require 'rake/testtask'

Rails::TestTask.new("test:lib"=>'test:prepare') do |t|
    t.libs = ['test/lib']
    t.test_files = FileList["test/lib/**/*_test.rb"]
    t.verbose = true
    t.warning = true
end
