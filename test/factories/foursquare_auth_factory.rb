FactoryGirl.define do
  factory :foursquare_auth do
    association :user, factory: :active_user
  end
end
