FactoryGirl.define do
  factory :foursquare_auth do
    association :user, factory: :active_user

    factory :foursquare_auth_complete do
      auth_token Rails.application.config.vcr_tokens["foursquare"][:auth_token]
    end

    if !Rails.application.config.auth["foursquare"][:auth_token].empty?
      factory :foursquare_auth_complete_live do
        auth_token Rails.application.config.auth["foursquare"][:auth_token]
      end
    end
  end
end
