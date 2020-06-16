require 'rails_helper'

RSpec.describe TeamUsersController, type: :controller do
  include Devise::Test::ControllerHelpers

  before(:each) do
    request.env["HTTP_ACCEPT"] = 'application/json'

    @request.env["devise.mapping"] = Devise.mappings[:user]
    @current_user = FactoryGirl.create(:user)
    sign_in @current_user
  end

  describe "GET #crete" do
    # Sem isto os testes não renderizam o json
    render_views

    context "Team owner" do
      before(:each) do
        @team = create(:team, user: @current_user)
        @guest_user = create(:user)

        post :create, params: { team_user: { email: @guest_user.email, team_id: @team.id } }
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "Return the right params" do
        response_hash = JSON.parse(response.body)

        expect(response_hash["user"]["name"]).to eql(@guest_user.name)
        expect(response_hash["user"]["email"]).to eql(@guest_user.email)
        expect(response_hash["team_id"]).to eql(@team.id)
      end
    end

    context "Team not owner" do
      before(:each) do
        @team = create(:team)
        @guest_user = create(:user)
      end

      it "returns http forbidden" do
        post :create, params: { team_user: { email: @guest_user.email, team_id: @team.id } }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "GET #destroy" do
    context "Team owner" do
      before(:each) do
        @team = create(:team, user: @current_user)
        @guest_user = create(:user)
        @team.users << @guest_user
      end

      it "returns http success" do
        delete :destroy, params: { id: @guest_user.id, team_id: @team.id }
        expect(response).to have_http_status(:success)
      end
    end

    context "Team not owner" do
      before(:each) do
        @team = create(:team)
        @guest_user = create(:user)
        @team.users << @guest_user
      end

      it "returns http forbidden" do
        delete :destroy, params: { id: @guest_user.id, team_id: @team.id }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'index' do

    context 'when user has open team_user' do
      before :each do
        create(:team)
        create(:user)
        create(:team_user, user: @current_user)
        get :index
      end
      it 'is expected to return it' do
        response_body = JSON.parse response.body
        expect(response_body["invites"].size).to eq 1
      end
      it 'is expected to return a :ok status' do
        expect(response).to have_http_status :ok
      end
    end
    context 'when user has none open team_user' do
      before :each do
        get :index
      end
      it 'is expected to return :not found status' do
        expect(response).to have_http_status :not_found
      end
    end

  end

  describe "update team_user" do
    context 'when current user accept invite' do
      before :each do
        user = create(:user)
        create(:team, user: user)
        @team_user = create(:team_user, user: @current_user)
        patch :update, params: { id: @team_user.id, team_user: { confirmation_status: :confirmed } }
      end
      it 'is expected to return :ok' do
        expect(response).to have_http_status :ok
      end
      it 'is expected to return team_user' do
        response_body = JSON.parse response.body
        expect(response_body["team_user"]["id"]).to match @team_user.id
        expect(response_body["team_user"]["confirmation_status"]).to eq "confirmed"
      end
    end
    context 'when user try to update status from other user' do
      before :each do
        user = create(:user)
        create(:team, user: user)
        second_user = create(:user)
        @team_user = create(:team_user, user: second_user)
        patch :update, params: { id: @team_user.id, team_user: { confirmation_status: :confirmed }}
      end
      it 'is expected to return assess_denied' do
        expect(response).to have_http_status :forbidden
      end
    end
  end

end
