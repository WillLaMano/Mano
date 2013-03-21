class GroupsController < ApplicationController
  before_filter :require_user, only: [:new, :create, :mine]
  
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
