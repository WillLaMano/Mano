class UsersGroups < ActiveRecord::Base
  attr_accessible :group_id, :user_id
  
  belongs_to :group
  belongs_to :user
  
  validates :group_id, presence: true
  validates :user_id, presence: true
end
