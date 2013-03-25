class GroupInviteMailer < ActionMailer::Base
  default from: "from@example.com"
  
  def invite_email(group, user, email)
    @group = group
    @user = user
    @url = "http://localhost:3000/"
    mail(:to => email, :subject => "You've been invited!")
  end
end
