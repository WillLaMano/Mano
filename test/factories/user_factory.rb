FactoryGirl.define do
  sequence :email do |n|
    email "thomas#{n}@wdpk837.com"
  end

  factory :user do
    name "Thomas B"
    password "password"
    password_confirmation "password"
    email
  end
end