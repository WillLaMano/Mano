ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'authlogic/test_case'
require 'vcr'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all
  VCR.configure do |c|
    c.cassette_library_dir = "test/vcr_cassettes"
    c.hook_into :webmock
  end

  # Add more helper methods to be used by all tests here...
end
