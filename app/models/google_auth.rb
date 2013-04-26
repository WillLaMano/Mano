class Google_Auth < Authorization

  def self.model_name
    Authorization.model_name
  end
  
  def auth_type
    return "Google"
  end

  def access_client
    auth_client_obj = OAuth2::Client.new(Rails.application.config.auth[:google][:client_id], Rails.application.config.auth[:google][:client_secret], {:site => 'https://accounts.google.com', :authorize_url => "/o/oauth2/auth", :token_url => "/o/oauth2/token"})
    auth_client_obj
  end

  def access_url
    url=self.access_client.auth_code.authorize_url(:scope => Rails.application.config.auth[:google][:scope], :access_type => "offline", :redirect_uri =>Rails.application.config.auth[:google][:redirect_uri])
  end

  def access_token
    access_token_obj = OAuth2::AccessToken.new(self.access_client,auth_token,{:refresh_token=>refresh_token, :expires_at=>expires_at.to_i})
    if access_token_obj.expired?
      refresh = access_token_obj.refresh!
      self.auth_token=refresh.token
    self.expires_at=DateTime.strptime(refresh.expires_at.to_s,"%s")
      self.save!
      access_token_obj = OAuth2::AccessToken.new(self.access_client,auth_token,{:refresh_token=>refresh_token, :expires_at=>expires_at.to_i})
    end

    return access_token_obj
  end

  def google_client
    client = Google::APIClient.new
    token = self.access_token
    client.authorization.update_token!(:access_token=>token.token, :refresh_token=>token.refresh_token,:expired_in=>(expires_at-Time.now.to_i))
    client
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
    access_token = access_client.auth_code.get_token(params[:code],{:redirect_uri=>Rails.application.config.auth[:google][:redirect_uri],:token_method=>:post})
    self.auth_token=access_token.token
    self.refresh_token=access_token.refresh_token
    self.expires_at=DateTime.strptime(access_token.expires_at.to_s,"%s")
    rescue
      self.errors.add :base,"Couldn't get Google authorization!!"
    end
  end

  def get_current_location
    client = self.google_client
    api = client.discovered_api("latitude")
    result = client.execute(
      :api_method => api.current_location.get,
      :parameters => {:granularity => "best"}
    )
    ActiveSupport::JSON.decode(result.body)["data"]
  end

  def get_current_events
    client = self.google_client
    api=client.discovered_api("calendar","v3")
    cal_list = ActiveSupport::JSON.decode(client.execute(
      :api_method => api.calendar_list.list,
      :parameters => {"minAccessRole" => "reader"}
    ).body)
    ids= cal_list["items"].select{|i|!i["selected"].nil?}.map{|i|i["id"]}
    events = [];
    batch = Google::APIClient::BatchRequest.new do |result|
      unless result.data["items"].empty?
        events += result.data["items"]
      end
    end
    ids.each do |id|
      batch.add(
        :api_method => api.events.list,
        :parameters => {"calendarId" => id,
          "timeMax"=> 15.minutes.from_now.xmlschema,
          "timeMin"=> Time.now.xmlschema
      })
    end
    client.execute(batch)
    events
  end

end
