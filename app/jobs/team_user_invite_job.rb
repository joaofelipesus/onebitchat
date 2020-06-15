class TeamUserInviteJob < ApplicationJob
  queue_as :default

  def perform(team_user)
    TeamUserMailer.invite(team_user).deliver_now!
  end
end
