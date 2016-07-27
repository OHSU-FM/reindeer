namespace :seed do
  namespace :create do
    desc 'Create base admin user'
    task :admin => :environment do
      u=User.new; 
      u.username = ENV['ADMIN_NAME']
      u.email = ENV['ADMIN_EMAIL']
      u.full_name = ENV['ADMIN_FULL_NAME']
      u.password = ENV['ADMIN_PASS']
      u.password_confirmation = ENV['ADMIN_PASS']
      u.superadmin=true
      puts ENV
      u.save!
    end
  end
end

