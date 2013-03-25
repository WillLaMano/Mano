class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  
  has_many :users_groups
  has_many :groups, through: :users_groups
  has_many :authorizations
  
  acts_as_authentic do |c|
    c.login_field = 'email'
  end
  
  def instagram
    return self.authorizations.find(:first, :conditions => [ "type = 'Instagram_Auth'"])
  end

  def new_service_allowed?
    !Authorization.services.delete_if{|a|
      self.authorizations.any?{|b|
        b.auth_type.downcase==a.downcase
      }}.empty?
  end
  
end
