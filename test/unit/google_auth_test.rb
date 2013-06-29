require 'test_helper'
require 'open-uri'

class GoogleAuthTest < ActiveSupport::TestCase
  test "Auth Type should be Google" do
    google_auth = FactoryGirl.create :google_auth
    assert_equal "Google", google_auth.auth_type, "Google_Auth Auth Type should be 'Google'"
   end

  test "Access URL" do
    google_auth = FactoryGirl.create :google_auth

    url = "https://accounts.google.com/o/oauth2/auth?response_type=code&"
    url += "client_id=#{Rails.application.config.auth["google"][:client_id]}&"
    url += "scope=#{CGI.escape Rails.application.config.auth["google"][:scope]}&"
    url += "access_type=offline&"
    url += "redirect_uri=#{CGI.escape Rails.application.config.auth["google"][:redirect_uri]}"

    assert_equal url, google_auth.access_url
  end

  test "Access Token should be valid" do
    google_auth = FactoryGirl.create :google_auth_complete
    
    VCR.use_cassette('google/test_access_token') do
      token = google_auth.access_token
      parsed_response = JSON.parse(token.get(
        "https://www.googleapis.com/oauth2/v2/userinfo"
      ).response.body)

      assert_equal "115664013910475403282", parsed_response["id"], "Returned Access Token should be valid"
      assert_equal google_auth.access_client, token.client, "Returned client should be correct"
      assert_equal google_auth.auth_token,token.token,  "Access Token token should be from DB"
    end
  end

  test "Google Client" do
    google_auth = FactoryGirl.create :google_auth_complete

    VCR.use_cassette('google/google_client') do
    client = google_auth.google_client

        oauth_nfo = client.discovered_api("oauth2")
        result = JSON.parse(client.execute(:api_method => oauth_nfo.userinfo.get).body)
        assert_equal "115664013910475403282", result["id"], "Return ID should be correct"
    end
  end

  test "Create GoogleAuth" do
    google_auth = GoogleAuth.new
    google_auth_authorized = FactoryGirl.create :google_auth_complete

    VCR.use_cassette('google/auth_callback') do
      google_auth.params={:code=> "4/WLsBLvLWgqB1FtMJpRkNpoDq2L9c.8vBDqH8jXeYTmmS0T3UFEsPcuzTmfQI"}

      assert_nothing_raised "Saving shouldn't raise errors" do
        google_auth.save!
      end       
      assert_equal google_auth_authorized.auth_token, google_auth.auth_token, "Auth Tokens should match"
      assert_equal google_auth_authorized.auth_secret, google_auth.auth_secret, "Auth Tokens should match"
    end
  end

  test "Get Current Location" do
    google_auth = FactoryGirl.create :google_auth_complete

    VCR.use_cassette("google/get_current_location") do
      correct_location = {"kind"=>"latitude#location", "timestampMs"=>"1369960405323", "latitude"=>42.3475777, "longitude"=>-71.0633747, "accuracy"=>717} 

      assert_equal correct_location, google_auth.get_current_location, "Location should be correct"
    end
  end

  test "Get Current Events" do
    google_auth = FactoryGirl.create :google_auth_complete

    VCR.use_cassette("google/get_current_events") do
      correct_events = ["2013_BIRTHDAY_1962be578d914329", "2013_BIRTHDAY_self", "_74rj0dr66gs64dr2ckpjgdb56op34c1n6hgjechhcosm2oplchhjgophcpj38c1n81q74qbgd5q2sorfdk", "0uuv37if4r86kqh7nb4npscph0", "olgcaai60jrd2vgitodlgun2ec"] 


      assert_equal correct_events, google_auth.get_current_events.map{|event|event.id}, "Events should be correct"
    end
  end
end
