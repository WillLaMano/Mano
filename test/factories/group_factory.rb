FactoryGirl.define do
  sequence :name do |n|
    name "group#{n}"
  end

  factory :group do
    name
  end
end