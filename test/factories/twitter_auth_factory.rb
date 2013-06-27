FactoryGirl.define do
  factory :twitter_auth do
    association :user, factory: :active_user

    factory :twitter_auth_complete do
      auth_token Rails.application.config.vcr_tokens["twitter"][:auth_token]
      auth_token Rails.application.config.vcr_tokens["twitter"][:auth_secret]
    end

    if !Rails.application.config.auth["twitter"][:auth_token].empty?
      factory :twitter_auth_complete_live do
        auth_token Rails.application.config.auth["twitter"][:auth_token]
        auth_secret Rails.application.config.auth["twitter"][:auth_secret]
      end
    end
  end
end
