class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  has_many :api_tokens
  
  acts_as_authentic do |c|
    c.login_field = 'email'
  end
  
end
