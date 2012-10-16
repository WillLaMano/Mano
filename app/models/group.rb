class Group < ActiveRecord::Base
  attr_accessible :name
  
  has_many :users_groups
  has_many :users, through: :users_groups
  
  validates :name, presence: true
  
end
