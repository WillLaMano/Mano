class Authorization < ActiveRecord::Base
  attr_accessible :auth_token, :auth_type, :user_id, :refresh_token, :expires_at
  attr_accessor :params
  belongs_to :user

  validate :check_access_token
  validates :user_id, :auth_token, :presence => true

  def self.services
    ["Google","Instagram","Twitter","Facebook","Foursquare"]
  end

end
