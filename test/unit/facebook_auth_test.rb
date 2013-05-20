require 'test_helper'
require 'open-uri'

class FacebookAuthTest < ActiveSupport::TestCase
  test "Auth Type should be Facebook" do
    fb_auth = FactoryGirl.create :facebook_auth
    assert_equal "Facebook", fb_auth.auth_type, "FB_Auth Auth Type should be 'Facebook'"
   end

  test "Access Token should be valid" do
    fb_auth = FactoryGirl.create :fb_auth_complete
    
    VCR.use_cassette('fb/test_access_token') do
      token = fb_auth.access_token
      parsed_response = JSON.parse(token.get(
        "https://graph.facebook.com/me?fields=id"
      ).response.body)

      assert_equal "504653228", parsed_response["id"], "Returned Access Token should be valid"
      assert_equal fb_auth.access_client, token.client, "Returned client should be correct"
      assert_equal fb_auth.auth_token,token.token,  "Access Token token should be from DB"
      assert_equal fb_auth.expires_at.to_i,token.expires_in,  "Access Token Expiration should be from DB"
    end
  end

  test "Access Client should be valid" do
    fb_auth = FactoryGirl.create :facebook_auth
    client =fb_auth.access_client

    assert_equal Rails.application.config.auth[:facebook][:client_id], client.id, "Checking Client ID"
    assert_equal Rails.application.config.auth[:facebook][:client_secret], client.secret, "Checking Client Secret"
    assert_equal 'https://www.facebook.com', client.site, "Checking Client Site"
    assert_equal "dialog/oauth", client.options[:authorize_url], "Checking Authorize URL"
    assert_equal "https://graph.facebook.com/oauth/access_token", client.options[:token_url], "Checking Token URL"
  end

  test "Access URL should be correct" do
    fb_auth = FactoryGirl.create :facebook_auth

    correct_url = "https://www.facebook.com/dialog/oauth?response_type=code&"
    correct_url += "client_id=#{CGI.escape Rails.application.config.auth[:facebook][:client_id]}&"
    correct_url += "redirect_uri=#{CGI.escape Rails.application.config.auth[:facebook][:redirect_uri]}&"
    correct_url += "scope=#{CGI.escape Rails.application.config.auth[:facebook][:scope]}"

    assert_equal correct_url, fb_auth.access_url, "URL should be a valid url"
  end

  test "Return Valid Koala Client" do
    fb_auth = FactoryGirl.create :fb_auth_complete
    koala = fb_auth.facebook_client

    assert_equal fb_auth.auth_token, koala.access_token, "Compare Access Token to DB Auth Token"
  end

  test "Creating FB_auth" do
    fb_auth = FacebookAuth.new
    fb_auth_authorized = FactoryGirl.create :fb_auth_complete

    VCR.use_cassette('fb/auth_callback') do
      fb_auth.params={:code=> "AQBtxU2YfKf0J0iQtRMwLae5X5vcZdZuvr3L-hjTyJHKk0rtSwOmd3Xzo2y06DlXdA7hpwx1uUJ-9coOz5aIbJwy9WCTBkvftQLTp9-4vrnSo21xlA1Vy7gBZOX-z1s2DU5jSgk27uavqYb3H1Ts4jM6UEcdHUCWjQdSRKdsArdaLAZn4k2H7XAmP7XzAaXt7qmv5exvqMzVAegzBryE8Q_9TSnzCR87UXm3oHeKIB_CYcwobxDrmcdNnNi-sP_5-8aE8M-JvDV9j2itPNL5Upbjfd7rIiCDaptZ-ZuQPDh7XAVMMIF0U-xUk0KkOC4Pqlc"}
      
      assert_nothing_raised "Saving shouldn't raise errors" do
        fb_auth.save!
      end       
      assert_equal fb_auth_authorized.auth_token, fb_auth.auth_token, "Auth Tokens should match"
    end
  end

  test "Getting Statuses no limit" do
    fb_auth = FactoryGirl.create :fb_auth_complete

    VCR.use_cassette('fb/get_statuses_no_limit') do
      correct_statuses =  ["I'm fine! Scary day though.", "Dear Friends in Pittsburgh,\n\nDo you want to run the PGH Half Marathon but didn't buy tickets?! It's your lucky day! I hurt my Achilles training for said marathon and am looking to sell my ticket to someone. Yes this is actually possible to do, message me in some fashion of you're interested or know somebody who is.", "Interested in helping CMU EMS out? Want free pizza and to be painted with scars and other bodily injuries? Then come help us with our Multiple Casualty Incident Drill this Saturday from 11am-3pm. Email jdivone@andrew or respond if you're interested. It will be fun I promise.", "Wanna help CMU EMS? Wanna get backboarded? Wanna be awesome? Then help us out and be a patient this Sunday at 2pm for a mass casualty incident drill! Comment if you can help out.", "Phone not working... Find other ways of communicating with me!", "Back in McLean for the next week...Give me a call if you're around", "is dumb and leaves his facebook logged in in the AB office which is strange cause hes never on facebook", "wonders why Adam Kriegel is such a hunk!"]

      assert_equal correct_statuses, fb_auth.get_statuses, "Returned statuses should be correct"
    end
  end

  test "Getting Statuses limit 5" do
    fb_auth = FactoryGirl.create :fb_auth_complete

    VCR.use_cassette('fb/get_statuses_limit_5') do
      correct_statuses = ["I'm fine! Scary day though.", "Dear Friends in Pittsburgh,\n\nDo you want to run the PGH Half Marathon but didn't buy tickets?! It's your lucky day! I hurt my Achilles training for said marathon and am looking to sell my ticket to someone. Yes this is actually possible to do, message me in some fashion of you're interested or know somebody who is.", "Interested in helping CMU EMS out? Want free pizza and to be painted with scars and other bodily injuries? Then come help us with our Multiple Casualty Incident Drill this Saturday from 11am-3pm. Email jdivone@andrew or respond if you're interested. It will be fun I promise.", "Wanna help CMU EMS? Wanna get backboarded? Wanna be awesome? Then help us out and be a patient this Sunday at 2pm for a mass casualty incident drill! Comment if you can help out.", "Phone not working... Find other ways of communicating with me!"] 

      assert_equal correct_statuses, fb_auth.get_statuses(5), "Returned statuses should be correct"
    end
  end

  test "Get Profile Picture" do
    fb_auth = FactoryGirl.create :fb_auth_complete

    VCR.use_cassette("fb/get_profile_picture") do
      correct_profile_pic = "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-prn1/573659_504653228_939663551_q.jpg" 

      assert_equal correct_profile_pic, fb_auth.get_profile_picture, "Returned Profile Pic should be correct"
    end
  end
end
