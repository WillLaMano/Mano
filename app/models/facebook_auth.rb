class Facebook_Auth < Authorization

  def self.model_name
    Authorization.model_name
  end
  
  def auth_type
    return "Facebook"
  end

  def access_client
    # parsing code from http://stackoverflow.com/questions/8864093/sinatra-logging-in-to-facebook-oauth-2-0-using-gem-oauth2
    OAuth2::Response.register_parser(:facebook, 'text/plain') do |body|
            token_key, token_value, expiration_key, expiration_value = body.split(/[=&]/)
            {token_key => token_value, expiration_key => expiration_value, :mode => :query, :param_name => 'access_token'}
    end
    
    auth_client_obj = OAuth2::Client.new(Rails.application.config.auth[:facebook][:client_id], Rails.application.config.auth[:facebook][:client_secret], {:site => 'https://www.facebook.com', :authorize_url => "dialog/oauth", :token_url => "https://graph.facebook.com/oauth/access_token"})
    auth_client_obj
  end

  def access_url(user_id)
    permissions = "user_location,user_events,user_photos,user_status"
    url=self.access_client.auth_code.authorize_url(:state => user_id, :response_type => "code", :redirect_uri => Rails.application.config.auth[:facebook][:redirect_uri], :scope => permissions)
  end

  def access_token
    access_token_obj = OAuth2::AccessToken.new(self.access_client,auth_token,:expires_in=>expires_in.to_i)
    return access_token_obj
  end
  
  def facebook_client
    client = Koala::Facebook::API.new(auth_token)
    client
  end

  def is_expired?
    return self.access_token.expired?
  end

  def check_valid?(result)
    true
  end

  def check_access_token
    access_client = self.access_client
    begin
    access_token = access_client.auth_code.get_token(code,{:redirect_uri=>Rails.application.config.auth[:facebook][:redirect_uri],:token_method=>:post, :parsed => :facebook})
    self.auth_token=access_token.token
    self.expires_at=DateTime.strptime((Time.now.to_i+access_token.expires_in).to_s,"%s")
    rescue
      self.errors.add :base, "Couldn't get Facebook authorization!!"
    end
  end

  def get_statuses(limit = 10)
    client = self.facebook_client
    statuses = client.get_connection("me", "statuses", {:fields => 'message', :limit => 10})
    statuses = statuses.map{|x| x["message"]}.compact
    statuses
  end

end
