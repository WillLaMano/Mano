require 'test_helper'

class AuthorizationsControllerTest < ActionController::TestCase

  setup :activate_authlogic


  setup do
    @fb_auth = FactoryGirl.create :facebook_auth
    @user = @fb_auth.user
    @session = UserSession.create(@user)

  end

  test "should FB redirect to correct url" do
    post :create, :provider=>"facebook"
    assert_redirected_to @fb_auth.access_url, "Redirect to FBAuth Access URL"
  end

  test "Should FB Handle Callback" do
    @fb_auth_authorized = FactoryGirl.create :fb_auth_complete

    VCR.use_cassette('fb_callback') do
      get :callback, :provider => "facebook",:code=> "AQBtxU2YfKf0J0iQtRMwLae5X5vcZdZuvr3L-hjTyJHKk0rtSwOmd3Xzo2y06DlXdA7hpwx1uUJ-9coOz5aIbJwy9WCTBkvftQLTp9-4vrnSo21xlA1Vy7gBZOX-z1s2DU5jSgk27uavqYb3H1Ts4jM6UEcdHUCWjQdSRKdsArdaLAZn4k2H7XAmP7XzAaXt7qmv5exvqMzVAegzBryE8Q_9TSnzCR87UXm3oHeKIB_CYcwobxDrmcdNnNi-sP_5-8aE8M-JvDV9j2itPNL5Upbjfd7rIiCDaptZ-ZuQPDh7XAVMMIF0U-xUk0KkOC4Pqlc"
      received_auth = assigns("authorization")
      assert_equal @fb_auth_authorized.auth_token, received_auth.auth_token, "Check Auth Token is Correct"
      assert_instance_of FacebookAuth, received_auth, "Check returned auth is a FB auth"
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
