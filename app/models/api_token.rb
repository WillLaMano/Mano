class ApiToken < ActiveRecord::Base
  attr_accessible :access_token, :api_type, :user_id
  
  validates :access_token, presence: true
  validates :api_type, presence: true
  validates :user_id, presence: true
  
  belongs_to :user
end
