class GroupsController < ApplicationController
  before_filter :require_user, only: [:new, :create, :mine, :invited, :join]
  
  def show
    @group = Group.find(params[:id])
    authorize! :manage, @group
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @group }
    end
  end
  
  # TODO: this is currently only a convenience and should be removed eventually
  def index
    @groups = Group.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @groups }
    end
  end
  
  def mine
    @groups = current_user.groups
    respond_to do |format|
      format.html { render :template => 'groups/index' } # index.html.erb
      format.json { render json: @groups }
    end
  end
  
  def new
    @group = Group.new
  end
  
  def create
    @group = Group.new(params[:group])
    if @group.save
      @group.users_groups.create(:user_id => current_user.id)
      flash[:notice] = "Your group has been created."
      redirect_to group_path(@group)
    else
      flash[:notice] = "There was a problem creating your group."
      render :action => :new
    end
  end
  
  def edit
    @group = Group.find(params[:id])
    authorize! :manage, @group
  end
  
  def update
    @group = Group.find(params[:id])
    authorize! :manage, @group

    if @group.update_attributes(params[:group])
      flash[:notice] = "Group updated!"
      redirect_to group_path
    else
      render :action => :edit
    end
  end
  
  def invited
    @invite = GroupInvitation.find_by_token(params[:token])
    @group = @invite.group
    @members = @group.users
    
    if @members.include?(current_user)
      flash[:notice] = "You are already a part of #{@group.name}."
      redirect_to group_path(@group)
    else
      respond_to do |format|
        format.html # join.html.erb
      end
    end
  end
  
  def join
    # This isn't very DRY
    @invite = GroupInvitation.find_by_token(params[:token])
    @group = @invite.group
    @members = @group.users
    
    if @members.include?(current_user)
      flash[:notice] = "You are already a part of #{@group.name}."
    else
      flash[:notice] = "You have joined #{@group.name}"
      @group.users_groups.create(:user_id => current_user.id)
    end
    
    redirect_to group_path(@group)
    
    # Delete the invite? Mark for deletion?
  end
  
  def leave
    @group = Group.find(params[:id])
    authorize! :manage, @group
    
    @user_group = UsersGroups.find_by_user_id_and_group_id(current_user.id, @group.id)
    @user_group.destroy
    
    redirect_to root_path
  end
  
end
