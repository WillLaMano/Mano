require 'test_helper'

class PageControllerTest < ActionController::TestCase
  
  setup :activate_authlogic
  
  setup do
    @group = FactoryGirl.create(:group_with_users)
    @user = @group.users.first
    UserSession.create(@user)
  end
    
  test "should get feed" do
    get :feed, :id => @group
    assert_response :success
  end
  
  test "should get current status" do
    get :current_status, :id => @group
    assert_response :success
  end

end
