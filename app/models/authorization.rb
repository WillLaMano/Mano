class Authorization < ActiveRecord::Base
  attr_accessible :auth_token, :type, :user_id, :refresh_token, :expires_at
  attr_accessor :code
  validate :check_access_token


end
