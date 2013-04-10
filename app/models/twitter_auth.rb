class Twitter_Auth < Authorization

  attr_accessible :auth_secret

  def self.model_name
    Authorization.model_name
  end
  
  def auth_type
    return "Twitter"
  end

  def access_client
    auth_client_obj = OAuth::Consumer.new(Rails.application.config.auth[:twitter][:client_id],
                                          Rails.application.config.auth[:twitter][:client_secret],
                                          {:site => "https://api.twitter.com",
                                            :request_token_path => "/oauth/request_token",
                                            :access_token_path => "/oauth/access_token",
                                            :authorize_path => "/oauth/authorize",
                                            :scheme => :header
                                        })
    auth_client_obj
  end

  def request_token(args={})
    client = self.access_client
    if args[:request_token].nil?
      @request_token = client.get_request_token :oauth_callback => Rails.application.config.auth[:twitter][:redirect_uri]
    else
      @request_token = OAuth::RequestToken.new(client,args[:request_token],args[:request_secret])
    end
  end

  def access_url
    @request_token.authorize_url
  end

  def twitter_client
    Twitter::Client.new(:oauth_token => self.auth_token, :oauth_token_secret=>self.auth_secret)
  end

  def check_access_token
    begin
      access_token = @request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
      self.auth_token=access_token.token
      self.auth_secret=access_token.secret

    rescue=>e
      self.errors.add :base,e.message
    end
  end
  
  def get_tweets
    client = self.twitter_client
    tweets = client.user_timeline(:count => 10)
    tweets
  end

end
