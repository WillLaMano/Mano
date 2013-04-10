class GroupInvitationsController < ApplicationController
  before_filter :require_user
  
  # GET /group/:id/invite
  def new
    @group_invitation = GroupInvitation.new
    @group = Group.find(params[:id])

    @group_invitation.group_id=@group.id
    authorize! :manage, @group
    
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # POST /group_invitations
  def create
    @group = Group.find(params[:group_invitation][:group_id])
    authorize! :manage, @group
    
    @group_invitation = GroupInvitation.new(params[:group_invitation])
    @group_invitation.user_id = current_user.id
    
    respond_to do |format|
      if @group_invitation.save

        GroupInviteMailer.invite_email(@group, current_user, @group_invitation).deliver        
        format.html { redirect_to @group, notice: 'Group invitation was successfully sent.' }
      else
        format.html { render action: "new" }
      end
    end
  end

end
