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

  config.action_mailer.default_url_options = { :host => 'localhost', :port => "3000" }
  ActionMailer::Base.default :from => "brian@mano.com"

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
      :sanitize_search => "access_token="
    },
    :foursquare => {
      :auth_token => "XSBKF53RKJ3BDNNQ4P1ES4J5O0XJXTYZIZ0NWJRAETYWW4SC",
      :sanitize_search => "oauth_token="
    }
  }

  config.auth = {
    :google => {
      :client_id=>"",
      :client_secret=>"",
      :redirect_uri=>"http://localhost:3000/authorizations/callback/google",
      :scope =>"https://www.googleapis.com/auth/calendar.readonly https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/latitude.current.best",
      :host =>""
    },

    :instagram => {
      :client_id=>"",
      :client_secret=>"",
      :redirect_uri=>"http://localhost:3000/authorizations/callback/instagram",
      :host => ""
    },

    # Directions to get Twitter Auth Token/Secret
    # This is much more annoying... May be easier to just yank from the DB
    # 1. Go to https://dev.twitter.com/console
    # 2. In the "Authentication" dropdown go to "OAuth 1"
    # 3. Login (if needed) and hit allow
    # 3. You'll see the page refresh and now you'll have your account in the 
    #    Authentication dropdown.
    # 4. Right click anywhere and inspect element.
    # 5. Refresh the page
    # 6. Go to the Network tab of the element inspector.
    # 7. Look for the fethUserCredentials request. Sort by Type..it'll make
    #    that easier. It's a application/json response.
    # 8. Click on the fetchUserCredentials item, choose the "Response" tab
    # 9. Look for the "secret" and "token" keys in the json response
    # 10. Those are you secret/token
    
    :twitter => {
      :client_id=>"",
      :client_secret=>"",
      :redirect_uri=>"http://localhost:3000/authorizations/callback/twitter",
      :host =>"",
      :auth_token=>"",
      :auth_secret=>""
    },
    # Directions to get Foursquare Auth Token
    # 1. Go to https://developer.foursquare.com/docs/explore
    # 2. If it's your first time, hit "Allow"
    # 3. Copy the oauth_token=<token>!

    :foursquare => {
      :client_id=>"",
      :client_secret=>"",
      :redirect_uri=>"http://localhost:3000/authorizations/callback/foursquare",
      :host => "api.foursquare.com",
      :auth_token => ""
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
      :client_id=>"",
      :client_secret=>"",
      :redirect_uri=>"http://localhost:3000/authorizations/callback/facebook",
      :scope =>"user_location,user_events,user_photos,user_status",
      :host => "graph.facebook.com",
      :auth_token=>"",
      :expires_at=>""
    },

  }

end
