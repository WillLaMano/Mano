class GroupInvitation < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  
  attr_accessible :invitee_email, :token, :group_id
  
  before_create :generate_token

  validates :group, :presence => true
  validates :user, :presence => true

  private
  def generate_token
    self.token = Digest::SHA1.hexdigest([Time.now, rand].join)
  end
  
  
end
