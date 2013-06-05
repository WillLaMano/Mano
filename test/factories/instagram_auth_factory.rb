FactoryGirl.define do
  factory :instagram_auth do
    association :user, factory: :active_user

    factory :ig_auth_complete do
      auth_token "35119537.4019d1f.7491467b1c044eb393ed563d91169c01"
    end

  end
end
