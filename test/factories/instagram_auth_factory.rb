FactoryGirl.define do
  factory :instagram_auth do
    association :user, factory: :active_user

    factory :ig_auth_complete do
      auth_token Rails.application.config.vcr_tokens["instagram"][:auth_token]
    end

    if !Rails.application.config.auth["instagram"][:auth_token].empty?
      factory :ig_auth_complete_live do
        auth_token Rails.application.config.auth["instagram"][:auth_token]
      end
    end
  end
end
