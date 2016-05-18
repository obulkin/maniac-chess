require 'rails_helper'

RSpec.describe Pawn, type: :model do
  describe "#valid_move?" do
    let(:game) {create :game}

    it "should correctly evaluate malformed moves, including ones that are otherwise valid" do
      white_pawn = create :pawn, rank: 8, file: 8, game: game
      black_pawn = create :pawn, rank: 1, file: 1, color: "black", game: game
      expect(white_pawn.valid_move? 9, 8).to eq(false)
      expect(white_pawn.valid_move? 9, 9).to eq(false)
      expect(white_pawn.valid_move? 8, 9).to eq(false)
      expect(white_pawn.valid_move? 8, 0).to eq(false)
      expect(white_pawn.valid_move? 9, 0).to eq(false)
      expect(black_pawn.valid_move? 0, 1).to eq(false)
      expect(black_pawn.valid_move? 0, 0).to eq(false)
      expect(black_pawn.valid_move? 0, 9).to eq(false)
    end

    it "should correctly evaluate obstructed moves, including ones that are otherwise valid" do
      white_pawn = create :pawn, rank: 1, file: 5, game: game
      black_pawn = create :pawn, rank: 8, file: 5, color: "black", game: game
      expect(white_pawn.valid_move? 2, 5).to eq(false)
      expect(white_pawn.valid_move? 2, 4).to eq(false)
      expect(white_pawn.valid_move? 2, 6).to eq(false)
      expect(white_pawn.valid_move? 1, 4).to eq(false)
      expect(white_pawn.valid_move? 1, 6).to eq(false)
      expect(black_pawn.valid_move? 7, 4).to eq(false)
      expect(black_pawn.valid_move? 7, 5).to eq(false)
      expect(black_pawn.valid_move? 7, 6).to eq(false)
    end

    it "should correctly evaluate unobstructed, well-formed moves that a pawn can't make" do
      white_pawn = create :pawn, rank: 4, file: 5
      white_pawn.game.pieces.where(rank: 7).destroy_all
      expect(white_pawn.valid_move? 4, 4).to eq(false)
      expect(white_pawn.valid_move? 4, 6).to eq(false)
      expect(white_pawn.valid_move? 3, 4).to eq(false)
      expect(white_pawn.valid_move? 3, 5).to eq(false)
      expect(white_pawn.valid_move? 3, 6).to eq(false)
      expect(white_pawn.valid_move? 6, 3).to eq(false)
      expect(white_pawn.valid_move? 6, 7).to eq(false)
      expect(white_pawn.valid_move? 7, 5).to eq(false)

      black_pawn = create :pawn, rank: 5, file: 5, color: "black"
      black_pawn.game.pieces.where(rank: 2).destroy_all
      expect(black_pawn.valid_move? 5, 4).to eq(false)
      expect(black_pawn.valid_move? 5, 6).to eq(false)
      expect(black_pawn.valid_move? 6, 4).to eq(false)
      expect(black_pawn.valid_move? 6, 5).to eq(false)
      expect(black_pawn.valid_move? 6, 6).to eq(false)
      expect(black_pawn.valid_move? 3, 3).to eq(false)
      expect(black_pawn.valid_move? 3, 7).to eq(false)
      expect(black_pawn.valid_move? 2, 5).to eq(false)
    end

    it "should correctly evaluate valid basic pawn moves" do
      white_pawn = game.pieces.find_by(rank: 2, file: 5)
      black_pawn = game.pieces.find_by(rank: 7, file: 5)
      expect(white_pawn.valid_move? 3, 5).to eq(true)
      expect(black_pawn.valid_move? 6, 5).to eq(true)
    end

    it "should correctly evaluate valid and invalid double moves" do
      white_pawn = game.pieces.find_by(rank: 2, file: 5)
      black_pawn = game.pieces.find_by(rank: 7, file: 5)
      expect(white_pawn.valid_move? 4, 5).to eq(true)
      expect(black_pawn.valid_move? 5, 5).to eq(true)

      white_pawn = create :pawn, rank: 3, file: 5, game: game
      black_pawn = create :pawn, rank: 6, file: 5, color: "black", game: game
      expect(white_pawn.valid_move? 5, 5).to eq(false)
      expect(black_pawn.valid_move? 4, 5).to eq(false)
    end

    it "should correctly evaluate valid and invalid capture moves" do
      white_pawn = create :pawn, rank: 6, file: 5, game: game
      black_pawn = create :pawn, rank: 3, file: 5, color: "black", game: game
      expect(white_pawn.valid_move? 7, 4).to eq(true)
      expect(white_pawn.valid_move? 7, 6).to eq(true)
      expect(black_pawn.valid_move? 2, 4).to eq(true)
      expect(black_pawn.valid_move? 2, 6).to eq(true)

      white_pawn = create :pawn, rank: 5, file: 5, game: game
      black_pawn = create :pawn, rank: 4, file: 5, color: "black", game: game
      expect(white_pawn.valid_move? 6, 4).to eq(false)
      expect(white_pawn.valid_move? 6, 6).to eq(false)
      expect(black_pawn.valid_move? 3, 4).to eq(false)
      expect(black_pawn.valid_move? 3, 6).to eq(false)
    end

    it "should correctly evaluate valid and invalid en passant captures" do
      white_pawn = create :pawn, rank: 7, file: 5, game: game
      black_pawn = create :pawn, rank: 2, file: 5, color: "black", game: game
      game.pieces.where(rank: 1).destroy_all
      game.pieces.where(rank: 8).destroy_all
      expect(white_pawn.valid_move? 8, 4).to eq(false)
      expect(white_pawn.valid_move? 8, 6).to eq(false)
      expect(black_pawn.valid_move? 1, 4).to eq(false)
      expect(black_pawn.valid_move? 1, 6).to eq(false)

      game.pieces.find_by(rank: 7, file: 4).update_en_passant 9
      game.pieces.find_by(rank: 7, file: 6).update_en_passant 9
      game.pieces.find_by(rank: 2, file: 4).update_en_passant 0
      game.pieces.find_by(rank: 2, file: 6).update_en_passant 0
      expect(white_pawn.valid_move? 8, 4).to eq(true)
      expect(white_pawn.valid_move? 8, 6).to eq(true)
      expect(black_pawn.valid_move? 1, 4).to eq(true)
      expect(black_pawn.valid_move? 1, 6).to eq(true)
    end
  end
end
