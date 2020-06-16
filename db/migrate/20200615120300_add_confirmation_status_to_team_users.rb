class AddConfirmationStatusToTeamUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :team_users, :confirmation_status, :integer, nulll: false
  end
end
