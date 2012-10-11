Rails.application.config.middleware.use OmniAuth::Builder do
    provider :twitter, 'CONSUMER_KEY', 'CONSUMER_SECRET'
    provider :facebook, 'APP_ID', 'APP_SECRET'
    # Mention other providers here you want to allow user to sign in with
end