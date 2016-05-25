require 'rails_helper'

RSpec.describe Queen, type: :model do
  describe "#valid_move?" do
    let(:game) {create :game}

    it "should properly evaluate malformed moves that would otherwise be valid" do
      white_queen = game.pieces.find_by(rank: 1, file: 1)
      white_queen2 = game.pieces.find_by(rank: 1, file: 8)
      white_queen3 = game.pieces.find_by(rank: 1, file: 3)
      black_queen = game.pieces.find_by(rank: 8, file: 1)
      black_queen2 = game.pieces.find_by(rank: 8, file: 8)
      black_queen3 = game.pieces.find_by(rank: 8, file: 3)
      expect(white_queen.valid_move?(1, 1)).to eq(false)
      expect(white_queen.valid_move?(0, 1)).to eq(false)
      expect(white_queen.valid_move?(1, 0)).to eq(false)
      expect(white_queen.valid_move?(0, 0)).to eq(false)
      expect(white_queen2.valid_move?(1, 9)).to eq(false)
      expect(white_queen2.valid_move?(0, 9)).to eq(false)
      expect(white_queen2.valid_move?(0, 8)).to eq(false)
      expect(white_queen3.valid_move?(0, 4)).to eq(false)
      expect(white_queen3.valid_move?(-2, 0)).to eq(false)
      expect(white_queen3.valid_move?(4, 0)).to eq(false)
      expect(white_queen3.valid_move?(-5, 9)).to eq(false)
      expect(white_queen3.valid_move?(7, 9)).to eq(false)
      expect(white_queen3.valid_move?(9, 11)).to eq(false)
      expect(white_queen3.valid_move?(9, -5)).to eq(false)
      expect(black_queen.valid_move?(8, 1)).to eq(false)
      expect(black_queen.valid_move?(8, 0)).to eq(false)
      expect(black_queen.valid_move?(9, 0)).to eq(false)
      expect(black_queen.valid_move?(9, 1)).to eq(false)
      expect(black_queen2.valid_move?(9, 8)).to eq(false)
      expect(black_queen2.valid_move?(9, 9)).to eq(false)
      expect(black_queen2.valid_move?(8, 9)).to eq(false)
      expect(black_queen3.valid_move?(9, 4)).to eq(false)
    end

    it "should properly evaluate obstructed moves that would otherwise be valid" do
      white_queen = game.pieces.find_by(rank: 1, file: 1)
      white_queen2 = game.pieces.find_by(rank: 1, file: 3)
      black_queen = game.pieces.find_by(rank: 8, file: 1)
      black_queen2 = game.pieces.find_by(rank: 8, file: 8)
      black_queen3 = game.pieces.find_by(rank: 8, file: 3)
      expect(white_queen.valid_move?(1, 2)).to eq(false)
      expect(white_queen.valid_move?(2, 1)).to eq(false)
      expect(white_queen2.valid_move?(2, 4)).to eq(false)
      expect(white_queen2.valid_move?(2, 2)).to eq(false)
      expect(black_queen.valid_move?(8, 2)).to eq(false)
      expect(black_queen.valid_move?(7, 1)).to eq(false)
      expect(black_queen2.valid_move?(8, 7)).to eq(false)
      expect(black_queen3.valid_move?(7, 4)).to eq(false)
      expect(black_queen3.valid_move?(7, 2)).to eq(false)
    end

    it "should properly evaluate unobstructed, well-formed moves that are not allowed for a Queen" do
      white_queen = game.pieces.create(type: "Queen", rank: 4, file: 4, color: "white")
      white_queen2 = game.pieces.create(type: "Queen", rank: 4, file: 5, color: "white")
      expect(white_queen.valid_move?(3, 2)).to eq(false)
      expect(white_queen.valid_move?(3, 6)).to eq(false)
      expect(white_queen.valid_move?(5, 2)).to eq(false)
      expect(white_queen.valid_move?(5, 6)).to eq(false)
      expect(white_queen2.valid_move?(5, 7)).to eq(false)
      expect(white_queen2.valid_move?(5, 3)).to eq(false)
      expect(white_queen2.valid_move?(6, 6)).to eq(false)
      expect(white_queen2.valid_move?(6, 4)).to eq(false)
      expect(white_queen2.valid_move?(3, 7)).to eq(false)
      expect(white_queen2.valid_move?(3, 3)).to eq(false)
      expect(white_queen2.valid_move?(2, 6)).to eq(false)
      expect(white_queen2.valid_move?(2, 4)).to eq(false)
    end

    it "should properly evaluate valid moves" do
      white_queen = game.pieces.create(type: "Queen", rank: 4, file: 4, color: "white")
      white_queen2 = game.pieces.create(type: "Queen", rank: 6, file: 5, color: "white")
      game.pieces.where(rank: 2).destroy_all
      expect(white_queen.valid_move?(4, 3)).to eq(true)
      expect(white_queen.valid_move?(4, 2)).to eq(true)
      expect(white_queen.valid_move?(4, 5)).to eq(true)
      expect(white_queen.valid_move?(4, 6)).to eq(true)
      expect(white_queen.valid_move?(3, 4)).to eq(true)
      expect(white_queen.valid_move?(2, 4)).to eq(true)
      expect(white_queen.valid_move?(5, 4)).to eq(true)
      expect(white_queen.valid_move?(6, 4)).to eq(true)
      expect(white_queen2.valid_move?(5, 4)).to eq(true)
      expect(white_queen2.valid_move?(5, 6)).to eq(true)
      expect(white_queen2.valid_move?(7, 4)).to eq(true)
      expect(white_queen2.valid_move?(7, 6)).to eq(true)
      expect(white_queen2.valid_move?(3, 2)).to eq(true)
      expect(white_queen2.valid_move?(4, 7)).to eq(true)
    end
  end
end
