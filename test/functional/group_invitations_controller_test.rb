require 'test_helper'

class GroupInvitationsControllerTest < ActionController::TestCase
  
  setup :activate_authlogic
  
  setup do
    @group_invitation = FactoryGirl.create(:group_invitation)
    @group = @group_invitation.group
    @user = @group_invitation.user
    UserSession.create(@user)
  end

  test "should get new" do
    get :new, :id => @group.id
    assert_response :success
  end

  test "should create group_invitation" do
    assert_difference('GroupInvitation.count') do
      post :create, group_invitation: { invitee_email: @group_invitation.invitee_email, token: @group_invitation.token, group_id: @group_invitation.group_id }
    end

    assert_redirected_to group_path(@group_invitation.group)
  end

end
