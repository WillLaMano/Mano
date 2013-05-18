FactoryGirl.define do
  factory :group_invitation do
    before(:create) do |invite|
      invite.group = FactoryGirl.create(:group_with_users, :users_count => 1)
      invite.user = invite.group.users.first
    end
    
    sequence(:invitee_email) { |n| "invitee{n}@example.com" }
        
  end
end
