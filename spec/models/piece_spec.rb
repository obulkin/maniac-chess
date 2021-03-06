require 'rails_helper'

RSpec.describe Piece, type: :model do
  let(:piece) {create :piece}

  describe "validations" do
    it "should not accept pieces without a type" do
      piece.type = nil
      expect(piece.save).to eq(false)
    end

    it "should not accept pieces with a type that doesn't match one of the allowed values" do
      piece.type = "Ace"
      expect(piece.save).to eq(false)
    end

    it "should not accept pieces without a color" do
      piece.color = nil
      expect(piece.save).to eq(false)
    end

    it "should not accept pieces with a color that doesn't match one of the allowed values" do
      piece.color = "red"
      expect(piece.save).to eq(false)
    end

    it "should not accept pieces without a rank" do
      piece.rank = nil
      expect(piece.save).to eq(false)
    end

    it "should not accept pieces with a rank outside the standard dimensions of a chess board" do
      piece.rank = 9
      expect(piece.save).to eq(false)
    end

    it "should not accept pieces without a file" do
      piece.file = nil
      expect(piece.save).to eq(false)
    end

    it "should not accept pieces with a file outside the standard dimensions of a chess board" do
      piece.file = -3
      expect(piece.save).to eq(false)
    end

    it "should not accept pieces without a game ID" do
      piece.game_id = nil
      expect(piece.save).to eq(false)
    end
  end

  describe "DB logic" do
    it "should not be eligible for en passant capture by default" do
      expect(piece.en_passant).to eq(false)
    end

    it "should not allow a game ID that doesn't correspond to a game" do
      piece = create :piece
      invalid_id = Game.last.id + 1
      piece.game_id = invalid_id
      expect{piece.save}.to raise_error(ActiveRecord::InvalidForeignKey)
    end

    it "should respond to game deletion by deleting any pieces with that game's ID" do
      ephemeral_game = piece.game
      piece_2 = create :piece, game_id: ephemeral_game.id
      ephemeral_game.delete
      expect{piece.reload}.to raise_error(ActiveRecord::RecordNotFound)
      expect{piece_2.reload}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "associations" do
    it "should be associated with a game based on game_id" do
      expect(piece.game.class).to eq(Game)
      expect(piece.game.id).to eq(piece.game_id)
    end
  end

  describe "#user" do
    it "should correctly return the owner of a white piece" do
      white_piece = create :piece, color: "white"
      expect(white_piece.user.id).to eq(white_piece.game.white_player.id)
    end

    it "should correctly return the owner of a black piece" do
      black_piece = create :piece, color: "black"
      expect(black_piece.user.id).to eq(black_piece.game.black_player.id)
    end
  end

  describe "#is_move_obstructed?" do
    let(:game) {create :game}

    describe "horizontal moves" do
      it "should detect adjacent obstructions" do
        test_king = game.pieces.find_by(rank: 1, file: 5)
        expect(test_king.send :is_move_obstructed?, 1, 6).to eq(true)
        expect(test_king.send :is_move_obstructed?, 1, 4).to eq(true)
      end

      it "should detect intermediate obstructions" do
        test_king = game.pieces.find_by(rank: 1, file: 5)
        game.pieces.where(rank: 1, file: 7).delete_all
        game.pieces.where(rank: 1, file: 3).delete_all
        expect(test_king.send :is_move_obstructed?, 1, 7).to eq(true)
        expect(test_king.send :is_move_obstructed?, 1, 3).to eq(true)
      end

      it "should detect obstructions at a remote move location" do
        test_king = game.pieces.find_by(rank: 1, file: 5)
        game.pieces.where(rank: 1, file: 6).delete_all
        game.pieces.where(rank: 1, file: 4).delete_all
        expect(test_king.send :is_move_obstructed?, 1, 7).to eq(true)
        expect(test_king.send :is_move_obstructed?, 1, 3).to eq(true)
      end

      it "should exclude captures from being treated as obstructions" do
        test_king = game.pieces.find_by(rank: 1, file: 5)
        game.pieces.where(rank: 1, file: 6).delete_all
        create :piece, rank: 1, file: 6, color: "black", game: game
        expect(test_king.send :is_move_obstructed?, 1, 6).to eq(false)
      end

      it "should correctly evaluate unobstructed moves" do
        game.pieces.where(rank: 1).delete_all
        test_king = create :piece, rank: 1, file: 5, game: game
        expect(test_king.send :is_move_obstructed?, 1, 3).to eq(false)
        expect(test_king.send :is_move_obstructed?, 1, 4).to eq(false)
        expect(test_king.send :is_move_obstructed?, 1, 6).to eq(false)
        expect(test_king.send :is_move_obstructed?, 1, 7).to eq(false)
      end
    end

    describe "vertical moves" do
      it "should detect adjacent obstructions" do
        white_rook = game.pieces.find_by(rank: 1, file: 8)
        black_rook = game.pieces.find_by(rank: 8, file: 8)
        expect(white_rook.send :is_move_obstructed?, 2, 8).to eq(true)
        expect(black_rook.send :is_move_obstructed?, 7, 8).to eq(true)
      end

      it "should detect intermediate obstructions" do
        white_rook = game.pieces.find_by(rank: 1, file: 8)
        black_rook = game.pieces.find_by(rank: 8, file: 8)
        expect(white_rook.send :is_move_obstructed?, 3, 8).to eq(true)
        expect(black_rook.send :is_move_obstructed?, 6, 8).to eq(true)
      end

      it "should detect obstructions at a remote move location" do
        white_king = create :piece, rank: 4, file: 8, game: game
        black_king = create :piece, rank: 5, file: 8, color: "black", game: game
        expect(white_king.send :is_move_obstructed?, 2, 8).to eq(true)
        expect(black_king.send :is_move_obstructed?, 7, 8).to eq(true)
      end

      it "should exclude captures from being treated as obstructions" do
        white_king = create :piece, rank: 5, file: 8, game: game
        black_king = create :piece, rank: 4, file: 8, color: "black", game: game
        expect(white_king.send :is_move_obstructed?, 7, 8).to eq(false)
        expect(black_king.send :is_move_obstructed?, 2, 8).to eq(false)
      end

      it "should correctly evaluate unobstructed moves" do
        game.pieces.where(file: 8).delete_all
        test_king = create :piece, rank: 4, file: 8, game: game
        expect(test_king.send :is_move_obstructed?, 2, 8).to eq(false)
        expect(test_king.send :is_move_obstructed?, 3, 8).to eq(false)
        expect(test_king.send :is_move_obstructed?, 5, 8).to eq(false)
        expect(test_king.send :is_move_obstructed?, 6, 8).to eq(false)
      end
    end

    describe "diagonal moves" do
      it "should detect adjacent obstructions" do
        white_bishop = game.pieces.find_by(rank: 1, file: 6)
        black_bishop = game.pieces.find_by(rank: 8, file: 6)
        expect(white_bishop.send :is_move_obstructed?, 2, 5).to eq(true)
        expect(white_bishop.send :is_move_obstructed?, 2, 7).to eq(true)
        expect(black_bishop.send :is_move_obstructed?, 7, 5).to eq(true)
        expect(black_bishop.send :is_move_obstructed?, 7, 7).to eq(true)
      end

      it "should detect intermediate obstructions" do
        white_king = create :piece, rank: 4, file: 5, game: game
        black_king = create :piece, rank: 5, file: 5, color: "black", game: game
        game.pieces.where(rank: 1).delete_all
        game.pieces.where(rank: 8).delete_all
        expect(white_king.send :is_move_obstructed?, 1, 2).to eq(true)
        expect(white_king.send :is_move_obstructed?, 1, 8).to eq(true)
        expect(black_king.send :is_move_obstructed?, 8, 2).to eq(true)
        expect(black_king.send :is_move_obstructed?, 8, 8).to eq(true)
      end

      it "should detect obstructions at a remote move location" do
        white_king = create :piece, rank: 4, file: 5, game: game
        black_king = create :piece, rank: 5, file: 5, color: "black", game: game
        expect(white_king.send :is_move_obstructed?, 2, 3).to eq(true)
        expect(white_king.send :is_move_obstructed?, 2, 7).to eq(true)
        expect(black_king.send :is_move_obstructed?, 7, 3).to eq(true)
        expect(black_king.send :is_move_obstructed?, 7, 7).to eq(true)
      end

      it "should exclude captures from being treated as obstructions" do
        white_king = create :piece, rank: 5, file: 5, game: game
        black_king = create :piece, rank: 4, file: 5, color: "black", game: game
        expect(white_king.send :is_move_obstructed?, 7, 3).to eq(false)
        expect(white_king.send :is_move_obstructed?, 7, 7).to eq(false)
        expect(black_king.send :is_move_obstructed?, 2, 3).to eq(false)
        expect(black_king.send :is_move_obstructed?, 2, 7).to eq(false)
      end

      it "should correctly evaluate unobstructed moves" do
        white_king = create :piece, rank: 5, file: 5, game: game
        black_king = create :piece, rank: 4, file: 5, color: "black", game: game
        expect(white_king.send :is_move_obstructed?, 4, 6).to eq(false)
        expect(white_king.send :is_move_obstructed?, 4, 4).to eq(false)
        expect(white_king.send :is_move_obstructed?, 3, 7).to eq(false)
        expect(white_king.send :is_move_obstructed?, 3, 3).to eq(false)
        expect(black_king.send :is_move_obstructed?, 5, 6).to eq(false)
        expect(black_king.send :is_move_obstructed?, 5, 4).to eq(false)
        expect(black_king.send :is_move_obstructed?, 6, 7).to eq(false)
        expect(black_king.send :is_move_obstructed?, 6, 3).to eq(false)
      end
    end
  end

  describe "#is_move_malformed?" do
    let(:white_king) {create :piece}

    it "should return true if a user moves a piece back to the same square" do
      expect(white_king.send :is_move_malformed?, 1, 1).to eq(true)
    end

    it "should return true if a user tries to move a piece outside the board" do
      expect(white_king.send :is_move_malformed?, 0, 8).to eq(true)
      expect(white_king.send :is_move_malformed?, 1, 9).to eq(true)
      expect(white_king.send :is_move_malformed?, 8, 9).to eq(true)
      expect(white_king.send :is_move_malformed?, 9, 8).to eq(true)
      expect(white_king.send :is_move_malformed?, 8, 0).to eq(true)
      expect(white_king.send :is_move_malformed?, 9, 1).to eq(true)
      expect(white_king.send :is_move_malformed?, 1, 0).to eq(true)
      expect(white_king.send :is_move_malformed?, 0, 1).to eq(true)
      expect(white_king.send :is_move_malformed?, 0, 9).to eq(true)
      expect(white_king.send :is_move_malformed?, 9, 9).to eq(true)
      expect(white_king.send :is_move_malformed?, 9, 0).to eq(true)
      expect(white_king.send :is_move_malformed?, 0, 0).to eq(true)
    end

    it "should return false if a move is well-formed" do
      expect(white_king.send :is_move_malformed?, 1, 2).to eq(false)
      expect(white_king.send :is_move_malformed?, 2, 1).to eq(false)
      expect(white_king.send :is_move_malformed?, 1, 8).to eq(false)
      expect(white_king.send :is_move_malformed?, 8, 1).to eq(false)
      expect(white_king.send :is_move_malformed?, 5, 4).to eq(false)
    end
  end

  describe "#capture_move?" do
    it "should return true for moves to a square with an enemy piece" do
      white_king = create :piece, rank: 7, file: 5
      black_king = create :piece, rank: 2, file: 5, color: "black"
      expect(white_king.capture_move? 8, 5).to eq(true)
      expect(white_king.capture_move? 8, 4).to eq(true)
      expect(white_king.capture_move? 8, 6).to eq(true)
      expect(white_king.capture_move? 7, 1).to eq(true)
      expect(white_king.capture_move? 7, 8).to eq(true)
      expect(black_king.capture_move? 1, 4).to eq(true)
      expect(black_king.capture_move? 1, 5).to eq(true)
      expect(black_king.capture_move? 1, 6).to eq(true)
    end

    it "should return false for moves to a square with a friendly piece" do
      game = create :game
      white_king = game.pieces.find_by rank: 1, file: 5
      black_king = game.pieces.find_by rank: 8, file: 5
      expect(white_king.capture_move? 1, 4).to eq(false)
      expect(white_king.capture_move? 1, 6).to eq(false)
      expect(white_king.capture_move? 2, 4).to eq(false)
      expect(white_king.capture_move? 2, 5).to eq(false)
      expect(white_king.capture_move? 2, 6).to eq(false)
      expect(black_king.capture_move? 7, 4).to eq(false)
      expect(black_king.capture_move? 7, 5).to eq(false)
      expect(black_king.capture_move? 7, 6).to eq(false)
    end

    it "should return false for moves to an empty square" do
      white_king = create :piece, rank: 5, file: 5
      expect(white_king.capture_move? 4, 4).to eq(false)
      expect(white_king.capture_move? 4, 5).to eq(false)
      expect(white_king.capture_move? 4, 6).to eq(false)
      expect(white_king.capture_move? 5, 4).to eq(false)
      expect(white_king.capture_move? 5, 6).to eq(false)
      expect(white_king.capture_move? 6, 4).to eq(false)
      expect(white_king.capture_move? 6, 5).to eq(false)
      expect(white_king.capture_move? 6, 6).to eq(false)
    end
  end

  describe "#update_en_passant" do
    let(:game) {create :game}

    it "should not change the en_passant attribute of a piece that isn't a pawn" do
      white_rook = create :piece, rank: 3, file: 1, type: "Rook", game: game
      white_knight = create :piece, rank: 3, file: 2, type: "Knight", game: game
      white_bishop = create :piece, rank: 3, file: 3, type: "Bishop", game: game
      white_queen = create :piece, rank: 3, file: 4, type: "Queen", game: game
      white_king = create :piece, rank: 3, file: 5, game: game
      expect{white_rook.update_en_passant 1}.to_not change(white_rook, :en_passant)
      expect{white_knight.update_en_passant 1}.to_not change(white_knight, :en_passant)
      expect{white_bishop.update_en_passant 1}.to_not change(white_bishop, :en_passant)
      expect{white_queen.update_en_passant 1}.to_not change(white_queen, :en_passant)
      expect{white_king.update_en_passant 1}.to_not change(white_king, :en_passant)

      black_rook = create :piece, rank: 6, file: 1, type: "Rook", color: "black", game: game
      black_knight = create :piece, rank: 6, file: 2, type: "Knight", color: "black", game: game
      black_bishop = create :piece, rank: 6, file: 3, type: "Bishop", color: "black", game: game
      black_queen = create :piece, rank: 6, file: 4, type: "Queen", color: "black", game: game
      black_king = create :piece, rank: 6, file: 5, color: "black", game: game
      expect{black_rook.update_en_passant 8}.to_not change(black_rook, :en_passant)
      expect{black_knight.update_en_passant 8}.to_not change(black_knight, :en_passant)
      expect{black_bishop.update_en_passant 8}.to_not change(black_bishop, :en_passant)
      expect{black_queen.update_en_passant 8}.to_not change(black_queen, :en_passant)
      expect{black_king.update_en_passant 8}.to_not change(black_king, :en_passant)
    end

    it "should not change the en_passant attribute of a pawn after a basic or capture move" do
      white_pawn = game.pieces.find_by rank: 2, file: 5
      black_pawn = game.pieces.find_by rank: 7, file: 5
      expect{white_pawn.update_en_passant 1}.to_not change(white_pawn, :en_passant)
      expect{black_pawn.update_en_passant 8}.to_not change(black_pawn, :en_passant)
    end

    it "should set the en_passant attribute of a pawn to true after a double move" do
      white_pawn = game.pieces.find_by rank: 2, file: 5
      black_pawn = game.pieces.find_by rank: 7, file: 5
      white_pawn.update_en_passant 0
      black_pawn.update_en_passant 9
      expect(white_pawn.en_passant).to eq(true)
      expect(black_pawn.en_passant).to eq(true)
    end
  end
end
