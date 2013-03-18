class GroupsController < ApplicationController
  before_filter :require_user, only: [:new, :create]
  
  def show
    @group = Group.find(params[:id])
    authorize! :manage, @group
  end
  
  def index
    @groups = Group.all
  end
  
  def new
    @group = Group.new
  end
  
  def create
    @group = Group.new(params[:group])
    if @group.save
      flash[:notice] = "Your group has been created."
      redirect_to root_path
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
  
  
end
