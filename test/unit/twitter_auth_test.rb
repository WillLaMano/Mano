require 'test_helper'
require 'open-uri'

class TwitterAuthTest < ActiveSupport::TestCase
  test "Auth Type should be Twitter" do
    twitter_auth = FactoryGirl.create :twitter_auth
    assert_equal "Twitter", twitter_auth.auth_type, "Twitter_Auth Auth Type should be 'Twitter'"
   end

  test "Access Token should be valid" do
    twitter_auth = FactoryGirl.create :twitter_auth_complete
    
    VCR.use_cassette('twitter/test_access_token') do
      token = twitter_auth.access_token
      parsed_response = JSON.parse(token.get(
        "https://api.twitter.com/1.1/account/settings.json"
      ).response.body)

      assert_equal "jmburges", parsed_response["screen_name"], "Returned Access Token should be valid"
      assert_equal twitter_auth.access_client, token.consumer, "Returned client should be correct"
      assert_equal twitter_auth.auth_token,token.token,  "Access Token token should be from DB"
      assert_equal twitter_auth.auth_secret,token.secret,  "Access Token secret should be from DB"
    end
  end

  test "Access Client" do
    twitter_auth = FactoryGirl.create :twitter_auth
    client =twitter_auth.access_client

    assert_equal Rails.application.config.auth["twitter"][:client_id], client.key, "Checking Client ID"
    assert_equal Rails.application.config.auth["twitter"][:client_secret], client.secret, "Checking Client Secret"
    assert_equal "https://api.twitter.com", client.site, "Checking Client Site"
    assert_equal "/oauth/authorize" , client.authorize_path, "Checking Authorize URL"
    assert_equal "/oauth/request_token", client.request_token_path, "Checking Request Token URL"
    assert_equal "/oauth/access_token", client.access_token_path, "Checking Access Token URL"
  end

  test "Access URL" do
    twitter_auth = FactoryGirl.create :twitter_auth

    correct_url = "https://api.twitter.com/oauth/authorize?"
    correct_url += "oauth_token=br1WwbwhV7MwSMwq8R3g3wqwY9TRdMY9QqSEgRK8"

    VCR.use_cassette("twitter/access_url") do
      assert_equal correct_url, twitter_auth.access_url, "URL should be a valid url"
    end
  end

  test "Return Valid Twitter Client" do
    twitter_auth = FactoryGirl.create :twitter_auth_complete
    twitter_client = twitter_auth.twitter_client
    
    VCR.use_cassette('twitter/test_access_token') do
      assert_equal "jmburges", twitter_client.settings.screen_name, "Returned Access Token should be valid"
    end

  end

  test "Creating Twitter_auth" do
    twitter_auth = TwitterAuth.new
    twitter_auth_authorized = FactoryGirl.create :twitter_auth_complete

    VCR.use_cassette('twitter/auth_callback') do

      twitter_auth.request_token({:request_token=>"0TghjHAUMDgDcqM6dH2PwlWM299I2Mjbzkm5LTbFEtU",
                                   :request_secret => "Xvz6JdLNmbWRunMQz04Fn4VQYOLr5opXwZWKussM"
                                  })
      twitter_auth.params={"oauth_token"=>"0TghjHAUMDgDcqM6dH2PwlWM299I2Mjbzkm5LTbFEtU", 
          "oauth_verifier"=>"PaFpWDliZ7aoAhfn1zpLfKwyZrBNGsstkZcq9QuZbwo"}
      
      assert_nothing_raised "Saving shouldn't raise errors" do
        twitter_auth.save!
      end       
      assert_equal twitter_auth_authorized.auth_token, twitter_auth.auth_token, "Auth Tokens should match"
      assert_equal twitter_auth_authorized.auth_secret, twitter_auth.auth_secret, "Auth Secret should match"
    end
  end

  test "Get Tweets" do
    twitter_auth_authorized = FactoryGirl.create :twitter_auth_complete

    VCR.use_cassette("twitter/get_tweets") do
      correct_ids = [339774144851898368, 338373364651524096, 337992085430996992, 337722156798603264, 336586230013767682] 
      retreived_tweets=twitter_auth_authorized.get_tweets(:count => 5)
      assert_equal correct_ids, retreived_tweets.map{|tweet| tweet.id}, "Check Correct Tweets"
    end
  end

  test "Get Oembed Tweets" do
    twitter_auth_authorized = FactoryGirl.create :twitter_auth_complete

    VCR.use_cassette("twitter/get_oembed_tweets") do
      retreived_tweets=twitter_auth_authorized.get_oembed_tweets(:count => 5)
      correct_tweets = ["https://twitter.com/jmburges/statuses/339774144851898368", "https://twitter.com/jmburges/statuses/338373364651524096", "https://twitter.com/jmburges/statuses/337992085430996992", "https://twitter.com/jmburges/statuses/337722156798603264", "https://twitter.com/jmburges/statuses/336586230013767682"] 
      assert_equal correct_tweets, retreived_tweets.map{|tweet| tweet.url}, "Check Correct Tweets"
      retreived_tweets.each do |tweet|
        assert_instance_of Twitter::OEmbed, tweet, "Check Oembeds are returned"
      end
    end
  end



end
