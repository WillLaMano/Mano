FactoryGirl.define do
  factory :facebook_auth do
    association :user, factory: :active_user

    factory :fb_auth_complete do
      auth_token Rails.application.config.vcr_tokens[:facebook][:auth_token]
      expires_at Time.now+5181906
    end
  end
end
