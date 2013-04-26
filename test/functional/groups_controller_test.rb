require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
  
  setup :activate_authlogic
  
  setup do
    @group = FactoryGirl.create(:group_with_users, :users_count => 1)
    @user = @group.users.first
    UserSession.create(@user)
  end
  
  # show 
  test "should get view" do
    get :show, :id => @group
    assert_response :success
  end
    
  # index
  test "the index should get my groups" do
    num_users_groups = 6
    user = FactoryGirl.create(:user_with_groups, :groups_count => num_users_groups)
    UserSession.create(user)
    FactoryGirl.create(:group)
    assert_equal(user.groups.size, num_users_groups)
    assert_not_equal(user.groups.size, Group.count)
    assert_operator(user.groups.size, :<, Group.count)

    get :index
    assert_response :success
    assert_equal(user.groups.size, assigns(:groups).size)
  end
    
  # new
  test "should get new" do
    get :new
    assert_response :success
  end

  # create
  test "should create group" do
    assert_difference('Group.count') do
      post :create, :group => { name: "new group" }
    end
    
    assert_redirected_to(assigns(:group))
    assert_equal "Your group has been created.", flash[:notice]
  end

  # edit
  test "should get edit" do
    get :edit, :id => @group
    assert_response :success
  end
  
  # update
  test "should update group" do
    old_name = @group.name
    new_name = old_name + "_new"
    put :update, :id => @group, group: { name: new_name }
    assert_redirected_to group_path(@group)
    assert_equal(new_name, assigns(:group).name)
    assert_not_equal(old_name, assigns(:group).name)
  end
  
  # invited
  # join
  # leave
  test "should leave group" do
    assert_difference('@group.users.count', -1) do
      delete :leave, :id => @group
    end
    assert_redirected_to root_url
  end

end
