require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:game) {create :game}

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

    it "should not allow a white player ID that doesn't correspond to a user" do
      game = create :game
      invalid_id = User.last.id + 1
      game.white_player_id = invalid_id
      expect{game.save}.to raise_error(ActiveRecord::InvalidForeignKey)
    end

    it "should not allow a black player ID that doesn't correspond to a user" do
      game = create :game
      invalid_id = User.last.id + 1
      game.black_player_id = invalid_id
      expect{game.save}.to raise_error(ActiveRecord::InvalidForeignKey)
    end
  end

  describe "associations" do
    it "should be associated with a user based on white_player_id" do
      expect(game.white_player.class).to eq(User)
      expect(game.white_player.id).to eq(game.white_player_id)
    end

    it "should be associated with a user based on black_player_id" do
      expect(game.black_player.class).to eq(User)
      expect(game.black_player.id).to eq(game.black_player_id)
    end

    it "should be associated with a number of pieces based on its ID" do
      (1..2).each {create :piece, game_id: game.id}
      game.pieces.each do |piece| 
        expect(piece).to be_kind_of(Piece)
        expect(piece.game_id).to eq(game.id)
      end
    end
  end

  describe "scopes" do
    it "should have an active scope that returns any games which have not yet ended in a draw or mate and no others" do
      game_1 = create :game, state: "open"
      game_2 = create :game, state: "white_in_check"
      game_3 = create :game, state: "black_in_check"
      game_4 = create :game, state: "white_in_mate"
      active_games = Game.active
      expect(active_games).to include(game_1)
      expect(active_games).to include(game_2)
      expect(active_games).to include(game_3)
      Game.active.each do |game|
        expect(game.state).to eq("open").or eq("white_in_check").or eq("black_in_check")
      end
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
