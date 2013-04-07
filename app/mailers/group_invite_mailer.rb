class GroupInviteMailer < ActionMailer::Base
  default from: "from@example.com"
  
  def invite_email(group, user, group_invitation)
    @group = group
    @user = user
    @url = invited_to_group_url(group_invitation.token)
    mail(:to => group_invitation.invitee_email, :subject => "You've been invited!")
  end
end
