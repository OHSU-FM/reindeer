#!/usr/bin/env ruby
u=User.new; 
u.name = ENV['ADMIN_NAME']
u.email = ENV['ADMIN_EMAIL']
u.full_name = ENV['ADMIN_FULL_NAME']
u.password = ENV['ADMIN_PASSWORD']
u.password_confirmation = ENV['ADMIN_PASSWORD']
u.superadmin=true
