FactoryGirl.define do
  factory :user do
    name "Thomas B"
    password "password"
    password_confirmation "password"
    sequence(:email) { |n| "thomas#{n}@wdpk837.com" }
    
    factory :active_user do
      after(:create) do |user, evaluator|
        user.activate!
      end
    end
  end
  
end
