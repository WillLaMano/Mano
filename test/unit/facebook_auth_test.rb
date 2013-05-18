require 'test_helper'

class FacebookAuthTest < ActiveSupport::TestCase
  test "Auth Type should be Facebook" do
    fb_auth = FactoryGirl.create :facebook_auth
    assert_equal fb_auth.auth_type, "Facebook", "FB_Auth Auth Type should be 'Facebook'"
   end
end
