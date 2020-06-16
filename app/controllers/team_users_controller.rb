class TeamUsersController < ApplicationController
  before_action :set_team_user, only: [:destroy]

  def index
    @invites = TeamUser.where(user: current_user).open
    if @invites.empty?
      render json: {}, status: :not_found
    else
      render json: { invites: @invites }, status: :ok, except: [:created_at, :updated_at], include: [:team, :user]
    end
  end

  def create
    @team_user = TeamUser.new(team_user_params)
    authorize! :create, @team_user
    respond_to do |format|
      if @team_user.save
        format.json { render :show, status: :created }
      else
        format.json { render json: @team_user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @team_user.team.user == current_user
      authorize! :destroy, @team_user
    elsif @team_user.team.team_users.where(user: current_user).empty?
      return render json: {}, status: :forbidden
    end
    @team_user.destroy
    respond_to do |format|
      format.json { render json: true }
    end
  end

  def update
    @team_user = TeamUser.find params[:id]
    authorize! :update, @team_user
    if @team_user.update params.require(:team_user).permit(:confirmation_status)
      render json: { team_user: @team_user }, status: :ok
    else
      render json: { errors: @team_user.errors.full_essages }, status: :unprocessable_entity
    end
  end

  private

  def set_team_user
    @team_user = TeamUser.find_by(user_id: params[:id], team_id: params[:team_id])
  end

  def team_user_params
    user = User.find_by(email: params[:team_user][:email])
    params.require(:team_user).permit(:team_id).merge(user_id: user.id)
  end
end
