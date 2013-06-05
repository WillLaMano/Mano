require 'test_helper'

class ActivationsControllerTest < ActionController::TestCase

  setup :activate_authlogic

  setup do
    @user = FactoryGirl.create :user
    @active_user = FactoryGirl.create :active_user
  end

  test "Activating User" do
    @user.reset_perishable_token!
    get :create, :activation_code=>@user.perishable_token
    assert_equal "Your account has been activated!", flash[:notice], "Check Flash Notice"
    assert_not_nil UserSession.find(@user), "Check Session is Created"
    assert_redirected_to root_url
    assert !ActionMailer::Base.deliveries.empty?, "Check Email is sent"
  end

  test "Active Users Gets Redirected" do
    UserSession.create(@active_user)

    get :create, :activation_code=>@active_user.perishable_token
    assert_redirected_to root_url
    assert_equal "You've already activated your account!", flash[:notice]
  end

  test "Incorrect Token Doesn't work" do
    @user.reset_perishable_token
    get :create, :activation_code=>@user.perishable_token

    assert_equal "Couldn't find that activation code", flash[:error], "Check Flash Error"
    assert_nil UserSession.find(@user), "Check Session isn't Created"
    assert_redirected_to root_url
  end

  test "Already Active User Doesn't Work" do
    @active_user.reset_perishable_token!
    get :create, :activation_code=>@active_user.perishable_token

    assert_equal "You're already activated", flash[:error], "Check Flash Error"
    assert_nil UserSession.find(@user), "Check Session isn't Created"
    assert_redirected_to root_url
  end

end
