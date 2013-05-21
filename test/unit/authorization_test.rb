require 'test_helper'

class AuthorizationTest < ActiveSupport::TestCase
   test "Should List All The Services" do
     services = Authorization.services
     assert_include services, "Google"
     assert_include services, "Instagram"
     assert_include services, "Facebook"
     assert_include services, "Foursquare"
   end
end
