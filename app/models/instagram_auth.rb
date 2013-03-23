class Instagram_Auth < Authorization

  after_initialize do
    self.auth_type="instagram"
  end

  def self.model_name
    Authorization.model_name
  end

  def access_client
    auth_client_obj = OAuth2::Client.new(Rails.application.config.auth[:instagram][:client_id], Rails.application.config.auth[:instagram][:client_secret], {:site => 'https://api.instagram.com', :authorize_url => "/oauth/authorize", :token_url => "/oauth/access_token"})
    auth_client_obj
  end

  def access_url(user_id)
    url=self.access_client.auth_code.authorize_url(:state => user_id, :response_type => "code", :redirect_uri => Rails.application.config.auth[:instagram][:redirect_uri])
  end

  def access_token
    access_token_obj = OAuth2::AccessToken.new(self.access_client,auth_token)
    return access_token_obj
  end

  def is_expired?
    false
  end

  def check_valid?(result)
    true
  end

  def check_access_token
    access_client = self.access_client
    begin
    access_token = access_client.auth_code.get_token(code,{:redirect_uri=>Rails.application.config.auth[:instagram][:redirect_uri],:token_method=>:post})
    self.auth_token=access_token.token
    rescue
      self.errors.add :base,"Couldn't get Instagram authorization!!"
    end
  end


end
