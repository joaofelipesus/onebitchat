class TeamUserMailer < ApplicationMailer

  def invite team_user
    @team_user = team_user
    mail(to: @team_user.user.email, subject: "You was invited to be a part of a new team !")
  end

end
