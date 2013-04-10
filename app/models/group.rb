class Group < ActiveRecord::Base
  attr_accessible :name
  
  has_many :users_groups
  has_many :users, through: :users_groups

  has_many :group_invitations
  
  validates :name, presence: true
  
end
