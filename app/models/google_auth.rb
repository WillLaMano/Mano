class Google_Auth < Authorization

  after_initialize do
    self.auth_type="google"
  end
  def self.model_name
    Authorization.model_name
  end
  def access_client
    auth_client_obj = OAuth2::Client.new(Rails.application.config.auth[:google][:client_id], Rails.application.config.auth[:google][:client_secret], {:site => 'https://accounts.google.com', :authorize_url => "/o/oauth2/auth", :token_url => "/o/oauth2/token"})
    auth_client_obj
  end

  def access_url(user_id)
    url=self.access_client.auth_code.authorize_url(:scope => Rails.application.config.auth[:google][:scope], :state => user_id, :access_type => "offline", :redirect_uri =>Rails.application.config.auth[:google][:redirect_uri])
  end

  def access_token
    access_token_obj = OAuth2::AccessToken.new(self.access_client,auth_token,{:refresh_token=>refresh_token, :expires_at=>expires_at.to_i})
    return access_token_obj
  end


  def is_expired?
    obj = self.access_token
    if obj.expired?
      begin
      obj=obj.refresh!
      rescue OAuth2::Error
        return true
      end
      self.auth_token=obj.token
      self.save!
      obj=self.auth_token
    end
    return false
  end

  def check_valid?(result)
    if(result.status!=200)
    raise result.error_message
    end
  end


  def check_access_token
    access_client = self.access_client
    begin
    access_token = access_client.auth_code.get_token(code,{:redirect_uri=>Rails.application.config.auth[:google][:redirect_uri],:token_method=>:post})
    self.auth_token=access_token.token
    self.refresh_token=access_token.refresh_token
    self.expires_at=DateTime.strptime(access_token.expires_at.to_s,"%s")
    rescue
      self.errors.add :base,"Couldn't get Google authorization!!"
    end
  end

end
