FactoryGirl.define do
  factory :google_auth do
    association :user, factory: :active_user

    factory :google_auth_complete do
      auth_token "ya29.AHES6ZS7kwkYEYtnKukriPzu9MowigcOOzNL1pfyrZuN4DoKgnbRVg"
      refresh_token "1/dEVsWtxoYW7_XY7TX5oCHgZubOGa5ZlV_Oqktqp0RWw"
      expires_at DateTime.strptime("1369964086","%s")
    end
  end
end
