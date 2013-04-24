FactoryGirl.define do
  factory :group do
    sequence(:name) { |n| "group#{n}" }

    factory :group_with_users do
      ignore do
        users_count 5
      end
      
      after(:create) do |group, evaluator|
        FactoryGirl.create_list(:active_user, evaluator.users_count, :groups => [group])
      end
    end
  end
  
end
