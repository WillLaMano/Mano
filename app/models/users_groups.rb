class UsersGroups < ActiveRecord::Base
  attr_accessible :group_id, :user_id
  
  belongs_to :group
  belongs_to :user
  
  validates :group_id, presence: true
  validates :user_id, presence: true
  
  before_destroy :remove_empty_group
  
  private
  # Delete the group if this is the last user
  def remove_empty_group
    group = self.group
    if group.users.size == 1
      group.destroy
    end
  end
  
end
