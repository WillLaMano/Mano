FactoryGirl.define do
  factory :facebook_auth do
    association :user, factory: :active_user

    factory :fb_auth_complete do
      auth_token "CAACb8HWIoOkBAAZAXDsB2UZAbjHAJnZBrlkrC8OsvNVKZCiU5rgjrcPEiByPcQ4uh4hH8Tn4w3mqjiaqMA2ZBGTLSb9Sym0nfogoyIhqLmvG9Q3fGkfJ1ZCwZC4KoXGO52cdOxWhyinF9DL1nas8IFowkyzU7G50PIZD"
      expires_at Time.now+5181906
    end
  end
end
