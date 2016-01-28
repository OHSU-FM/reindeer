ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/spec"
require "minitest/rails"

# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
require "minitest/rails/capybara"
require "minitest/pride"

# Requires supporting ruby files
Dir[Rails.root.join("test/support/**/*.rb")].each {|f| require f}
ActiveRecord::Migration.maintain_test_schema!

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
  fixtures :all

  # Add more helper methods to be used by all tests here...
  extend MiniTest::Spec::DSL
  include FactoryGirl::Syntax::Methods
end

class ActionController::TestCase

  fixtures :all
  include Devise::TestHelpers
  include FactoryGirl::Syntax::Methods
  include ControllerMacros
end

# Minitest::Spec
class Minitest::Spec
  include FactoryGirl::Syntax::Methods
end
