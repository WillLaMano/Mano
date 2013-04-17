class Authorization < ActiveRecord::Base
  attr_accessible :auth_token, :auth_type, :user_id, :refresh_token, :expires_at
  attr_accessor :params
  validate :check_access_token
  belongs_to :user

  def self.services
    ["Google","Instagram","Twitter","Foursquare"]
  end

end
