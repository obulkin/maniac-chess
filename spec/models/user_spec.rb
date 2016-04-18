require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#games" do
    let(:user) {create :user}
    
    it "should return an empty result set when a user is not part of any games" do
      create :game
      expect(user.games.empty?).to eq(true)
    end

    it "should return the games where the user is the white or black player and not any others" do
      game_1 = create :game, white_player_id: user.id
      game_2 = create :game, black_player_id: user.id
      game_3 = create :game

      expect(user.games.include? game_1).to eq(true)
      expect(user.games.include? game_2).to eq(true)
      expect(user.games.length).to eq(2)
    end
  end
end
