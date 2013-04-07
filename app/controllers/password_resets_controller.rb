class PasswordResetsController < ApplicationController
  # Method from: http://github.com/binarylogic/authlogic_example/blob/master/app/controllers/application_controller.rb
  before_filter :require_no_user
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]


  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_password_reset_instructions!
      flash[:notice] = "Instructions to reset your password have been emailed to you"
      redirect_to root_path
    else
      flash.now[:error] = "No user was found with email address #{params[:email]}"
      render :action => :new
    end
  end

  def new
    respond_to do |format|
      format.html
    end
  end


  def edit
    respond_to do |format|
      format.html
    end
  end



  def update
    @user.password = params[:password]
    @user.password_confirmation = params[:password]

    if @user.save
      flash[:success] = "Your password was successfully updated"
      redirect_to @user
    else
      render :action => :edit
    end
  end


  private

  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:error] = "We're sorry, but we could not locate your account"
      redirect_to root_url
    end
  end
end
