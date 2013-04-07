class Notifier < ActionMailer::Base
  default from: "from@example.com"

  def activation_instructions(user)
    @account_activation_url = activate_url(user.perishable_token)
    mail(:to => user.email, :subject => "Activation Instructions")
  end

  def welcome(user)
    @root_url = root_url
    mail(:to => user.email, :subject => "Welcome")
  end

  def password_reset_instructions(user)
    @edit_password_reset_url = edit_password_reset_url(user.perishable_token)
    mail(:to => user.email, :subject => "Password Reset Instructions")
  end
end
