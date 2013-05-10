class FoursquareAuth < Authorization

  def self.model_name
    Authorization.model_name
  end
  
  def auth_type
    return "Foursquare"
  end

  def access_client
    auth_client_obj = OAuth2::Client.new(Rails.application.config.auth[:foursquare][:client_id], Rails.application.config.auth[:foursquare][:client_secret], {:site => 'https://foursquare.com', :authorize_url => "/oauth2/authorize", :token_url => "/oauth2/access_token"})
    auth_client_obj
  end

  def access_url
    url=self.access_client.auth_code.authorize_url(:response_type => "code", :redirect_uri => Rails.application.config.auth[:foursquare][:redirect_uri])
  end

  def access_token
    access_token_obj = OAuth2::AccessToken.new(self.access_client,auth_token)
    return access_token_obj
  end

  def check_access_token
    access_client = self.access_client
    begin
    access_token = access_client.auth_code.get_token(params[:code],{:redirect_uri=>Rails.application.config.auth[:foursquare][:redirect_uri],:token_method=>:post})
    self.auth_token=access_token.token
    rescue
      self.errors.add :base, "Couldn't get Foursquare authorization!!"
    end
  end

  def foursquare_client
    Foursquare2::Client.new(:oauth_token => self.auth_token)
  end

  def get_last_checkin
    self.foursquare_client.user_checkins(:limit => 1)["items"][0]
  end

end
