require 'rails_helper'

RSpec.describe Rook, type: :model do
  describe "#valid_move?" do
    let(:game) {create :game}

    it "should properly evaluate malformed moves that are otherwise valid" do
      white_rook = game.pieces.find_by(rank: 1, file: 1)
      white_rook2 = game.pieces.find_by(rank: 1, file: 8)
      black_rook = game.pieces.find_by(rank: 8, file: 1)
      black_rook2 = game.pieces.find_by(rank: 8, file: 8)
      expect(white_rook.valid_move?(1, 1)).to eq(false)
      expect(white_rook.valid_move?(0, 1)).to eq(false)
      expect(white_rook.valid_move?(1, 0)).to eq(false)
      expect(white_rook.valid_move?(0, 0)).to eq(false)
      expect(white_rook2.valid_move?(1, 9)).to eq(false)
      expect(white_rook2.valid_move?(0, 9)).to eq(false)
      expect(white_rook2.valid_move?(0, 8)).to eq(false)
      expect(black_rook.valid_move?(8, 1)).to eq(false)
      expect(black_rook.valid_move?(8, 0)).to eq(false)
      expect(black_rook.valid_move?(9, 0)).to eq(false)
      expect(black_rook.valid_move?(9, 1)).to eq(false)
      expect(black_rook2.valid_move?(9, 8)).to eq(false)
      expect(black_rook2.valid_move?(9, 9)).to eq(false)
      expect(black_rook2.valid_move?(8, 9)).to eq(false)
    end

    it "should properly evaluate obstructed moves that are otherwise valid" do
      white_rook = game.pieces.find_by(rank: 1, file: 1)
      black_rook = game.pieces.find_by(rank: 8, file: 1)
      black_rook2 = game.pieces.find_by(rank: 8, file: 8)
      expect(white_rook.valid_move?(1, 2)).to eq(false)
      expect(white_rook.valid_move?(2, 1)).to eq(false)
      expect(black_rook.valid_move?(8, 2)).to eq(false)
      expect(black_rook.valid_move?(7, 1)).to eq(false)
      expect(black_rook2.valid_move?(8, 7)).to eq(false)
    end

    it "should properly evaluate unobstructed moves that are not allowed for a Rook but are otherwise valid" do
      white_rook = game.pieces.create(type: "Rook", rank: 4, file: 4, color: "white")
      expect(white_rook.valid_move?(3, 5)).to eq(false)
      expect(white_rook.valid_move?(3, 3)).to eq(false)
      expect(white_rook.valid_move?(5, 3)).to eq(false)
      expect(white_rook.valid_move?(5, 5)).to eq(false)
      expect(white_rook.valid_move?(3, 2)).to eq(false)
      expect(white_rook.valid_move?(3, 6)).to eq(false)
      expect(white_rook.valid_move?(5, 2)).to eq(false)
      expect(white_rook.valid_move?(5, 6)).to eq(false)
    end

    it "should properly evaluate valid moves" do
      white_rook = game.pieces.create(type: "Rook", rank: 4, file: 4, color: "white")
      game.pieces.where(rank: 2).destroy_all
      expect(white_rook.valid_move?(4, 3)).to eq(true)
      expect(white_rook.valid_move?(4, 2)).to eq(true)
      expect(white_rook.valid_move?(4, 5)).to eq(true)
      expect(white_rook.valid_move?(4, 6)).to eq(true)
      expect(white_rook.valid_move?(3, 4)).to eq(true)
      expect(white_rook.valid_move?(2, 4)).to eq(true) 
      expect(white_rook.valid_move?(5, 4)).to eq(true)
      expect(white_rook.valid_move?(6, 4)).to eq(true)   
    end
  end
end