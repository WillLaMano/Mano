class ActivationsController < ApplicationController
   before_filter {|c|require_no_user "You've already activated your account!"}
   def create
     @user = User.find_using_perishable_token(params[:activation_code], 1.week) || (raise Exception)
     raise Exception if @user.active?

     if @user.activate!
       flash[:notice] = "Your account has been activated!"
       UserSession.create(@user, false) # Log user in manually
       @user.deliver_welcome!
       redirect_to root_url
     else
       render :action => :new
     end
   end
end
