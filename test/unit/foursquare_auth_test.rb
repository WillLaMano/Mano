require 'test_helper'
require 'open-uri'

class FoursquareAuthTest < ActiveSupport::TestCase
  test "Auth Type should be Foursquare" do
    foursquare_auth = FactoryGirl.create :foursquare_auth
    assert_equal "Foursquare", foursquare_auth.auth_type, "foursquare_Auth Auth Type should be 'Foursquare'"
   end

  test "Access Token should be valid" do
    foursquare_auth = FactoryGirl.create :foursquare_auth_complete
    
    VCR.use_cassette('foursquare/test_access_token') do
      token = foursquare_auth.access_token
      parsed_response = JSON.parse(foursquare_auth.access_token.get("
        https://api.foursquare.com/v2/users/self?oauth_token=#{token.token}").response.body)

      assert_equal "10822719", parsed_response["response"]["user"]["id"], "Returned Access Token should be valid"
      assert_equal foursquare_auth.access_client, token.client, "Returned client should be correct"
      assert_equal foursquare_auth.auth_token,token.token,  "Access Token token should be from DB"
    end
  end

  test "Foursquare Client should be valid" do
    foursquare_auth = FactoryGirl.create :foursquare_auth_complete
    foursquare = foursquare_auth.foursquare_client

    VCR.use_cassette('foursquare/test_access_token') do
      assert_equal "10822719", foursquare.user('self').id
    end
  end

  test "Access Client should be valid" do
    foursquare_auth = FactoryGirl.create :foursquare_auth
    client =foursquare_auth.access_client

    assert_equal Rails.application.config.auth["foursquare"][:client_id], client.id, "Checking Client ID"
    assert_equal Rails.application.config.auth["foursquare"][:client_secret], client.secret, "Checking Client Secret"
    assert_equal 'https://foursquare.com', client.site, "Checking Client Site"
    assert_equal "/oauth2/authorize", client.options[:authorize_url], "Checking Authorize URL"
    assert_equal "/oauth2/access_token", client.options[:token_url], "Checking Token URL"
  end

  test "Access URL should be correct" do
    foursquare_auth = FactoryGirl.create :foursquare_auth
    correct_url = "https://foursquare.com/oauth2/authorize?response_type=code&"
    correct_url += "client_id=#{CGI.escape Rails.application.config.auth["foursquare"][:client_id]}&"
    correct_url += "redirect_uri=#{CGI.escape Rails.application.config.auth["foursquare"][:redirect_uri]}"

    assert_equal correct_url, foursquare_auth.access_url, "URL should be a valid url"
  end

  test "Get Last Checkin should be valid" do
    foursquare_auth = FactoryGirl.create :foursquare_auth_complete

    VCR.use_cassette("foursquare/get_last_checkin") do
      checkin = foursquare_auth.get_last_checkin

      assert_equal "519d7dcd498e5da246dc3675", checkin.id, "Checkin should be correct id"
    end
  end
end
