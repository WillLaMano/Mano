class ActivationsController < ApplicationController
   before_filter {|c|require_no_user "You've already activated your account!"}
   def create
     begin
     @user = User.find_using_perishable_token(params[:activation_code], 1.week) || (raise Exception,"Couldn't find that activation code")
     raise Exception, "You're already activated" if @user.active?

     if @user.activate!
       flash[:notice] = "Your account has been activated!"
       UserSession.create(@user, false) # Log user in manually
       @user.deliver_welcome!
     else
       raise Exception, "Sorry Activation Failed"
     end

     rescue Exception => e
       flash[:error] = e.message
     end

     respond_to do |format| 
       format.html {redirect_to root_url}
     end
   end
end
