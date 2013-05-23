FactoryGirl.define do
  factory :foursquare_auth do
    association :user, factory: :active_user

    factory :foursquare_auth_complete do
      auth_token "XSBKF53RKJ3BDNNQ4P1ES4J5O0XJXTYZIZ0NWJRAETYWW4SC"
    end
  end
end
