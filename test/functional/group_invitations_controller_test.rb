require 'test_helper'

class GroupInvitationsControllerTest < ActionController::TestCase
  setup do
    @group_invitation = group_invitations(:one)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create group_invitation" do
    assert_difference('GroupInvitation.count') do
      post :create, group_invitation: { invitee_email: @group_invitation.invitee_email, token: @group_invitation.token }
    end

    assert_redirected_to group_invitation_path(assigns(:group_invitation))
  end

end
