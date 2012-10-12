require "instagram"

class ApiTokensController < ApplicationController
  #this before_filter probably isn't the proper case for handling callbacks
  before_filter :require_user, only: [:instagram_authorize, :instagram_callback]
  
  INSTAGRAM_CALLBACK_URL = "http://localhost:3000/oauth/instagram/callback"
  
  def instagram_authorize
    redirect_to Instagram.authorize_url(:redirect_uri => INSTAGRAM_CALLBACK_URL)
  end
  
  def instagram_callback
    response = Instagram.get_access_token(params[:code], :redirect_uri => INSTAGRAM_CALLBACK_URL)
    access_token = response.access_token
    instagram_access_token = current_user.api_tokens.build(api_type: "instagram", access_token: access_token)
    instagram_access_token.save
    redirect_to :controller => 'users', :action => 'show'
  end
  
end
