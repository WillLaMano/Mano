FactoryGirl.define do
  factory :twitter_auth do
    association :user, factory: :active_user

    factory :twitter_auth_complete do
      auth_token "47312435-5jmXLVTIZiawYM544JayOOy2qfjLCNDMNAZhwzJl4"
      auth_secret "ES8BRb0gO64s2lhDMnCxEfJNSntzh1nhNOPLkxkCPwE"
    end
  end
end
