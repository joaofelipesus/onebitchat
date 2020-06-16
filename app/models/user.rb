class User < ApplicationRecord
  has_many :teams
  has_many :messages
  has_many :talks, dependent: :destroy
  has_many :team_users, dependent: :destroy
  has_many :member_teams, through: :team_users, :source => :team
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_one_attached :avatar

  def my_teams
    member_team_ids = TeamUser.where(user: self).confirmed.map { |team_user| team_user.team_id }
    self.teams + Team.where(id: member_team_ids)
  end
end
