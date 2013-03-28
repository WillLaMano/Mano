class GroupInviteMailer < ActionMailer::Base
  default from: "from@example.com"
  
  def invite_email(group, user, group_invitation)
    @group = group
    @user = user
    @url = "http://localhost:3000/groups/join/#{group_invitation.token}"
    mail(:to => group_invitation.invitee_email, :subject => "You've been invited!")
  end
end
