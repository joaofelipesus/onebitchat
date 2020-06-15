require 'rails_helper'

RSpec.describe TeamUser, type: :model do

  describe 'create team_user' do
    before :each do
      @team_user = FactoryGirl.build(:team_user)
    end
    context 'when missing required params' do
      after :each do
        expect(@team_user).to be_invalid
      end
      it 'is invalid when without user' do
        @team_user.user = nil
      end
      it 'is invalid when without team' do
        @team_user.team = nil
      end
    end
    it 'is expected to have default confirmation status as :open' do
      expect(@team_user).to be_valid
      expect(@team_user.open?).to be_truthy
    end
  end

end
