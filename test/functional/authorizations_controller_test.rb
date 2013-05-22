require 'test_helper'
require 'helpers/authorizations_helper'

class AuthorizationsControllerTest < ActionController::TestCase
  include AuthorizationsTestHelper
  setup :activate_authlogic


  setup do
    @fb_auth = FactoryGirl.create :facebook_auth
    @ig_auth = FactoryGirl.create :instagram_auth
    @user = @fb_auth.user
    @session = UserSession.create(@user)

  end

  test "should FB redirect to correct url" do
    check_correct_url("facebook",@fb_auth)
  end

  test "Should Handle FB Callback" do
    @fb_auth_authorized = FactoryGirl.create :fb_auth_complete

    VCR.use_cassette('fb/auth_callback') do
      get :callback, :provider => "facebook",:code=> "AQBtxU2YfKf0J0iQtRMwLae5X5vcZdZuvr3L-hjTyJHKk0rtSwOmd3Xzo2y06DlXdA7hpwx1uUJ-9coOz5aIbJwy9WCTBkvftQLTp9-4vrnSo21xlA1Vy7gBZOX-z1s2DU5jSgk27uavqYb3H1Ts4jM6UEcdHUCWjQdSRKdsArdaLAZn4k2H7XAmP7XzAaXt7qmv5exvqMzVAegzBryE8Q_9TSnzCR87UXm3oHeKIB_CYcwobxDrmcdNnNi-sP_5-8aE8M-JvDV9j2itPNL5Upbjfd7rIiCDaptZ-ZuQPDh7XAVMMIF0U-xUk0KkOC4Pqlc"
      received_auth = assigns("authorization")
      assert_equal @fb_auth_authorized.auth_token, received_auth.auth_token, "Check Auth Token is Correct"
      assert_instance_of FacebookAuth, received_auth, "Check returned auth is a FB auth"
    end
  end

  test "should Instagram redirect to correct url" do
    check_correct_url("instagram",@ig_auth)
  end

  test "Should Handle Instagram Callback" do
     @ig_auth_authorized = FactoryGirl.create :ig_auth_complete

    VCR.use_cassette('ig/auth_callback') do
      get :callback, :provider => "instagram",:code=> "eb9e7974fb02478ba8dfa84a58a57532"
      received_auth = assigns("authorization")
      assert_equal @ig_auth_authorized.auth_token, received_auth.auth_token, "Check Auth Token is Correct"
      assert_instance_of InstagramAuth, received_auth, "Check returned auth is a FB auth"
    end
  end
  
  test "Should Destroy Authorization" do
    assert_difference("Authorization.count",-1, "Check delete actually works") do
      delete :destroy, id: @fb_auth
    end

    assert_redirected_to authorizations_path, "Check Delete Redirect"
  end

  test "Should List Authorizations" do
    get :index
    assert_response :success, "Check Index Response is success"
    assert_includes assigns("authorizations"), @fb_auth, "Check index response has fb_auth"
  end



end
