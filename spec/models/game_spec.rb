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
      expect(game.pieces.count).to eq (32)
    end

    it "should be empty on the squares" do
      expect(game.pieces.where(rank: 3..6)).to eq([])
    end

    (1..8).each do |file|
      it "should have a white pawn at rank 2, file #{file}" do
        pieces = game.pieces.where(rank: 2 , file: file)
        expect(pieces.count).to eq(1)
        expect([pieces.first.type, pieces.first.color]).to eq(["Pawn", "white"])
      end

      it "should have a black pawn at rank 7, file #{file}" do
        pieces = game.pieces.where(rank: 7 , file: file)
        expect(pieces.count).to eq(1)
        expect([pieces.first.type, pieces.first.color]).to eq(["Pawn", "black"])
      end
    end

    {1 => "Rook", 2 => "Knight", 3 => "Bishop", 4 =>"Queen", 5 => "King", 6=> "Bishop", 7 => "Knight", 8 => "Rook"}.each do |file, type|  
      it "should have a correct type #{type} of white piece at rank 1, file #{file}" do
        pieces = game.pieces.where(rank: 1 , file: file)
        expect(pieces.count).to eq(1)
        expect([pieces.first.type, pieces.first.color]).to eq([type, "white"])
      end

      it "should have a correct type #{type} of black piece at rank 8, file #{file}" do
        pieces = game.pieces.where(rank: 8 , file: file)
        expect(pieces.count).to eq(1)
        expect([pieces.first.type, pieces.first.color]).to eq([type, "black"])
      end
    end  
  end
end
