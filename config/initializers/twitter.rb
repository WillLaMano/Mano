Twitter.configure do |config|
  config.consumer_key = Rails.application.config.auth["twitter"][:client_id]
  config.consumer_secret = Rails.application.config.auth["twitter"][:client_secret]
end
