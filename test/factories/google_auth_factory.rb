FactoryGirl.define do
  factory :google_auth do
    association :user, factory: :active_user

    factory :google_auth_complete do
      auth_token Rails.application.config.vcr_tokens["google"][:auth_token]
      refresh_token Rails.application.config.vcr_tokens["google"][:refresh_token]
      expires_at Time.now+3600
    end

    if !Rails.application.config.auth["google"][:auth_token].empty?
      factory :google_auth_complete_live do
        auth_token Rails.application.config.auth["google"][:auth_token]
        refresh_token Rails.application.config.auth["google"][:refresh_token]
        expires_at Time.at Rails.application.config.auth["google"][:expires_at]
      end
    end

  end
end
