require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
  
  setup :activate_authlogic
  
  setup do
    @group = FactoryGirl.create(:group_with_users)
    @user = @group.users.first
    UserSession.create(@user)
  end
  
  test "should get view" do
    get :show, :id => @group.id
    assert_response :success
  end

end
