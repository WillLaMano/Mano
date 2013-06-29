require 'test_helper'
require 'open-uri'

class InstagramAuthTest < ActiveSupport::TestCase
  test "Auth Type should be Instagram" do
    ig_auth = FactoryGirl.create :instagram_auth
    assert_equal "Instagram", ig_auth.auth_type, "IG_Auth Auth Type should be 'Instagram'"
   end

  test "Instagram Access Token should be valid" do
    ig_auth = FactoryGirl.create :ig_auth_complete
    
    VCR.use_cassette('instagram/test_access_token') do
      token = ig_auth.access_token
      parsed_response = JSON.parse(token.get(
        "https://api.instagram.com/v1/users/self.json?access_token=#{token.token}"
      ).response.body)

      assert_equal "35119537", parsed_response["data"]["id"], "Returned Access Token should be valid"
      assert_equal ig_auth.access_client, token.client, "Returned client should be correct"
      assert_equal ig_auth.auth_token,token.token,  "Access Token token should be from DB"
    end
  end

  test "Instagam Access URL should be valid" do
    ig_auth = FactoryGirl.create :instagram_auth
    
    correct_url = "https://api.instagram.com/oauth/authorize?response_type=code&"
    correct_url += "client_id=#{CGI.escape Rails.application.config.auth["instagram"][:client_id]}&"
    correct_url += "redirect_uri=#{CGI.escape Rails.application.config.auth["instagram"][:redirect_uri]}"

    assert_equal correct_url, ig_auth.access_url, "URL should be valid"
  end

  test "Access Client should be valid" do
    ig_auth = FactoryGirl.create :instagram_auth
    client =ig_auth.access_client

    assert_equal Rails.application.config.auth["instagram"][:client_id], client.id, "Checking Client ID"
    assert_equal Rails.application.config.auth["instagram"][:client_secret], client.secret, "Checking Client Secret"
    assert_equal 'https://api.instagram.com', client.site, "Checking Client Site"
    assert_equal "/oauth/authorize", client.options[:authorize_url], "Checking Authorize URL"
    assert_equal "/oauth/access_token", client.options[:token_url], "Checking Token URL"
  end

  test "Return Valid Instagram Client" do
    ig_auth = FactoryGirl.create :ig_auth_complete

    instagram = ig_auth.instagram_client

    assert_equal ig_auth.auth_token, instagram.access_token, "Compare Access Token to DB Auth Token"

    VCR.use_cassette('instagram/test_access_token') do
      assert_equal "35119537", instagram.user.id, "Checking IG user.id to known good"
    end
  end

  test "Return User Photos No Limit" do
    ig_auth = FactoryGirl.create :ig_auth_complete
    correct_ids = ["457877369827813629_35119537", "452274421118724112_35119537", "448588074596100919_35119537", "448493187779455381_35119537", "446337092327762589_35119537"]

    VCR.use_cassette("instagram/get_photos_no_limit") do
      photos = ig_auth.get_photos

      assert_equal photos.size, 5, "Should be 5 photos"
      assert_equal correct_ids, photos.map{|photo|photo.id}
    end

  end

  test "Return User Photos Limit 2" do
    ig_auth = FactoryGirl.create :ig_auth_complete
    correct_ids = ["457877369827813629_35119537", "452274421118724112_35119537"]
    VCR.use_cassette("instagram/get_photos_limit_2") do
      photos = ig_auth.get_photos(2)

      assert_equal photos.size, 2, "Should be 2 photos"
      assert_equal correct_ids, photos.map{|photo|photo.id}
    end

  end

end
