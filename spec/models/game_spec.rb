require 'rails_helper'

RSpec.describe Game, type: :model do
  let (:game) {create :game}

  describe "validations" do
    it "should not accept games without a name" do
      game.name = nil
      expect(game.save).to eq(false)
    end

    it "should not accept games without a player" do
      game.white_player_id = game.black_player_id = nil
      expect(game.save).to eq(false)
    end

    it "should not accept games where the two player IDs are the same" do
      game.black_player_id = game.white_player_id = 5
      expect(game.save).to eq(false)
    end

    it "should not accept games without a state" do
      game.state = nil
      expect(game.save).to eq(false)
    end

    it "should not accept games with a state that doesn't match one of the allowed values" do
      game.state = "willy_nilly"
      expect(game.save).to eq(false)
    end
  end

  describe "DB constraints" do
    it "should have white as unable to castle by default" do
      expect(game.white_can_castle).to eq(false)
    end

    it "should have black as unable to castle by default" do
      expect(game.black_can_castle).to eq(false)
    end

    it "should have white as next to move by default" do
      expect(game.white_to_move).to eq(true)
    end
  end

  describe "Populate Board" do
    it "should have correct number of pieces" do
      game = FactoryGirl.create(:game)
      expect(game.pieces.count).to eq 32
    end

    it "Pawn is in correct position" do
      game = FactoryGirl.create(:game)
      expect(game.pieces.first.type).to eq("Pawn")

      expected = [2, 1]
      expect([game.pieces.first.rank, game.pieces.first.file]).to eq(expected)
    end

    it "Rook is in correct position" do
      game = FactoryGirl.create(:game)
      expect(game.pieces.last.type).to eq("Rook")

      expected = [8, 8]
      expect([game.pieces.last.rank, game.pieces.last.file]).to eq(expected)
    end

    it "should successfully hook up the database relationship between pieces and games" do
      game = FactoryGirl.create(:game)
      piece = game.pieces.last
      expect(piece.game).to eq(game)
    end
  end  
end
