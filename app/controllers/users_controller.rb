class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    
    # Saving without session maintenance to skip
    # auto-login which can't happen here because
    # the User has not yet been activated
    if @user.save
      @user.deliver_activation_instructions!
      flash[:notice] = "Your account has been created. Please check your e-mail for your account activation instructions!"
      redirect_to root_url
    else
      flash[:notice] = "There was a problem creating you."
      render :action => :new
    end
    
  end

  def show
    @user = User.find(params[:id])
    authorize! :read, @user
  end
  
  def index
    @users = User.all
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to @user
    else
      render :action => :edit
    end
  end

def resend_activation
  if params[:email]
    @user = User.find_by_email params[:email]
    if @user && !@user.active?
      @user.deliver_activation_instructions!
      flash[:notice] = "Please check your e-mail for your account activation instructions!"
      redirect_to root_path
    end
  end
end
end
