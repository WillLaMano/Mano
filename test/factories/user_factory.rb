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
      
      factory :user_with_groups do
        ignore do
          groups_count 5
        end
        
        after(:create) do |user, evaluator|
          FactoryGirl.create_list(:group, evaluator.groups_count, :users => [user])
        end          
      end
    end
    
  end
  
end
