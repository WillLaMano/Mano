Mano::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true

  # Configure static asset server for tests with Cache-Control for performance
  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=3600"

  # Log error messages when you accidentally call methods on nil
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  config.action_mailer.default_url_options = { :host => ENV['url_host'], :port => ENV['url_port'] }
  ActionMailer::Base.default :from => ENV['from_email'] 

  # Raise exceptions instead of rendering exception templates
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment
  config.action_controller.allow_forgery_protection    = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Print deprecation notices to the stderr
  config.active_support.deprecation = :stderr
  
  config.vcr_tokens = {
    "facebook" => {
      :auth_token =>"CAACb8HWIoOkBAAZAXDsB2UZAbjHAJnZBrlkrC8OsvNVKZCiU5rgjrcPEiByPcQ4uh4hH8Tn4w3mqjiaqMA2ZBGTLSb9Sym0nfogoyIhqLmvG9Q3fGkfJ1ZCwZC4KoXGO52cdOxWhyinF9DL1nas8IFowkyzU7G50PIZD",
    },
    "foursquare" => {
      :auth_token => "XSBKF53RKJ3BDNNQ4P1ES4J5O0XJXTYZIZ0NWJRAETYWW4SC",
    },

    "instagram" => {
      :auth_token => "35119537.4019d1f.7491467b1c044eb393ed563d91169c01",
    },
    "twitter" => {
      :auth_token => "47312435-5jmXLVTIZiawYM544JayOOy2qfjLCNDMNAZhwzJl4",
      :auth_secret => "ES8BRb0gO64s2lhDMnCxEfJNSntzh1nhNOPLkxkCPwE",
    },
    "google" => {
      :auth_token => "ya29.AHES6ZS7kwkYEYtnKukriPzu9MowigcOOzNL1pfyrZuN4DoKgnbRVg",
      :refresh_token => "1/dEVsWtxoYW7_XY7TX5oCHgZubOGa5ZlV_Oqktqp0RWw",
  }
  }

  config.auth = {
    # Directions to get Google Auth Token
    # These are the same as Twitters
    # 1. Add the Google service to your account the normal way
    # 2. go to rails console
    # 3. find your user, and then do user_var.google to get the google info
    # 4. google.auth_token is the auth_token, google.refresh_token is the
    #    refresh_token, expires_at is the expires at...
    "google" => {
      :client_id=> ENV['google_client_id'],
      :client_secret=> ENV['google_client_secret'],
      :redirect_uri=>"http://localhost:3000/authorizations/callback/google",
      :scope =>"https://www.googleapis.com/auth/calendar.readonly https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/latitude.current.best",
      :auth_token => ENV['google_auth_token'],
      :refresh_token => ENV['google_refresh_token'],
      :expires_at => ENV['google_expires_at']
    },

    # Directions to get Instagram Auth Token
    # 1. Go to https://apigee.com/console/instagram
    # 2. Click on the Authentication drop down, select OAuth 2
    # 3. Accept the Instagram popup
    # 4. Open up the element inspector (right click > inspect element)
    # 5. Refresh the page and go to the Network tab of the element inspector
    # 6. Look for the fetchUserCredentials call. It's of type application/json
    #    so sorting by type is probably easiest.
    # 7. copy the token item.

    "instagram" => {
      :client_id=>ENV['instagram_client_id'],
      :client_secret=>ENV['instagram_client_secret'],
      :redirect_uri=>"http://localhost:3000/authorizations/callback/instagram",
      :auth_token=>ENV['instagram_auth_token'],
      :auth_secret=>ENV['instagram_auth_secret'] 
    },

    # Directions to get Twitter Auth Token/Secret
    # You can't use the twitter dev console be cause token/secrets work with
    # the oauth key and secret...
    # 1. Add the twitter service to your account the normal way
    # 2. go to rails console
    # 3. find your user, and then do user_var.twitter to get the twitter info
    # 4. twitter.auth_token is the token, twitter.auth_secret is the secret
    
    "twitter" => {
      :client_id=>ENV['twitter_client_id'],
      :client_secret=>ENV['twitter_client_secret'],
      :redirect_uri=>"http://localhost:3000/authorizations/callback/twitter",
      :auth_token=>ENV['twitter_auth_token'],
      :auth_secret=>ENV['twitter_auth_secret']
    },
    # Directions to get Foursquare Auth Token
    # 1. Go to https://developer.foursquare.com/docs/explore
    # 2. If it's your first time, hit "Allow"
    # 3. Copy the oauth_token=<token>!

    "foursquare"=> {
      :client_id=>ENV['foursquare_client_id'],
      :client_secret=>ENV['foursquare_client_secret'],
      :redirect_uri=>"http://localhost:3000/authorizations/callback/foursquare",
      :auth_token => ENV['foursquare_auth_token']
    },

    # Directions to Get Auth Token
    # 1. Go to https://developers.facebook.com/tools/explorer/
    # 2. Hit Get Access Token
    # 3. Choose the scopes that you want (probably the ones below)
    # 4. Hit Okay on popup
    # 5. Hit Debug
    # 6. The Auth Token is in the textfield at the top
    # 7. The expires_at is the expires number

    "facebook" => {
      :client_id=>ENV['facebook_client_id'],
      :client_secret=>ENV['facebook_client_secret'],
      :redirect_uri=>"http://localhost:3000/authorizations/callback/facebook",
      :scope =>"user_location,user_events,user_photos,user_status",
      :auth_token=>ENV['facebook_auth_token'],
      :expires_at=>ENV['facebook_expires_at']
    },

  }

end
