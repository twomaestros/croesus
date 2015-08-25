ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../test/test_app/config/environment', __FILE__)
require 'rails/test_help'
require 'rails/generators/test_case'
require 'minitest/reporters'
require 'capybara/rails'
require 'integration/integration_test_helpers'
require 'database_cleaner'
require 'byebug'

reporter_options = { color: true }
Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new(reporter_options)]

DatabaseCleaner.strategy = :truncation

OmniAuth.config.test_mode = true

class ActiveSupport::TestCase
  fixtures :all
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Croesus::Test::IntegrationTestHelpers
end