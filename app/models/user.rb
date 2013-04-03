class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  
  has_many :users_groups
  has_many :groups, through: :users_groups
  has_many :authorizations
  
  acts_as_authentic do |config|
    config.login_field = 'email'
    config.validate_email_field = false
  end
  
  def instagram
    return self.authorizations.find(:first, :conditions => [ "type = 'Instagram_Auth'"])
  end

  def google
    return self.authorizations.find(:first, :conditions => [ "type = 'Google_Auth'"])
  end

  def new_service_allowed?
    !Authorization.services.delete_if{|a|
      self.authorizations.any?{|b|
        b.auth_type.downcase==a.downcase
      }}.empty?
  end
  
  def activate!
    self.active = true
    save
  end

  def deliver_activation_instructions!
    reset_perishable_token!
    Notifier.activation_instructions(self).deliver
  end

  def deliver_welcome!
    reset_perishable_token!
    Notifier.welcome(self).deliver
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.password_reset_instructions(self).deliver
  end
  
end
