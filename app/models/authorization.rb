class Authorization < ActiveRecord::Base
  attr_accessible :auth_token, :auth_type, :user_id, :refresh_token, :expires_at
  attr_accessor :code
  validate :check_access_token

  def self.services
    ["Google","Instagram"]
  end

end
