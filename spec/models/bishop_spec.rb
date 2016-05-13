require 'rails_helper'

RSpec.describe Bishop, type: :model do
  describe "#valid_move?" do
    let(:game) {create :game}

    it "should correctly evaluate malformed moves, including ones that are otherwise valid" do
      white_bishop = game.pieces.find_by rank: 1, file: 3
      black_bishop = game.pieces.find_by rank: 8, file: 3
      game.pieces.where(rank: 2).destroy_all
      expect(white_bishop.valid_move? 0, 4).to eq(false)
      expect(white_bishop.valid_move? -2, 0).to eq(false)
      expect(white_bishop.valid_move? 4, 0).to eq(false)
      expect(white_bishop.valid_move? -5, 9).to eq(false)
      expect(white_bishop.valid_move? 7, 9).to eq(false)
      expect(white_bishop.valid_move? 9, 11).to eq(false)
      expect(white_bishop.valid_move? 9, -5).to eq(false)
      expect(black_bishop.valid_move? 9, 4).to eq(false)
    end

    it "should correctly evaluate obstructed moves, including ones that are otherwise valid" do
      white_bishop = game.pieces.find_by rank: 1, file: 3
      black_bishop = game.pieces.find_by rank: 8, file: 3
      expect(white_bishop.valid_move? 2, 4).to eq(false)
      expect(white_bishop.valid_move? 2, 2).to eq(false)
      expect(black_bishop.valid_move? 7, 4).to eq(false)
      expect(black_bishop.valid_move? 7, 2).to eq(false)
    end

    it "should correctly evaluate unobstructed, well-formed moves that a bishop can't make" do
      white_bishop = create :bishop, rank: 4, file: 5, game: game
      game.pieces.where(rank: 2).destroy_all
      expect(white_bishop.valid_move? 4, 4).to eq(false)
      expect(white_bishop.valid_move? 6, 5).to eq(false)
      expect(white_bishop.valid_move? 4, 8).to eq(false)
      expect(white_bishop.valid_move? 3, 5).to eq(false)
      expect(white_bishop.valid_move? 5, 7).to eq(false)
      expect(white_bishop.valid_move? 5, 3).to eq(false)
      expect(white_bishop.valid_move? 6, 6).to eq(false)
      expect(white_bishop.valid_move? 6, 4).to eq(false)
      expect(white_bishop.valid_move? 3, 7).to eq(false)
      expect(white_bishop.valid_move? 3, 3).to eq(false)
      expect(white_bishop.valid_move? 2, 6).to eq(false)
      expect(white_bishop.valid_move? 2, 4).to eq(false)
    end

    it "should correctly evaluate proper bishop moves" do
      white_bishop = create :bishop, rank: 4, file: 5, game: game
      game.pieces.where(rank: 2).destroy_all
      expect(white_bishop.valid_move? 3, 4).to eq(true)
      expect(white_bishop.valid_move? 3, 6).to eq(true)
      expect(white_bishop.valid_move? 5, 4).to eq(true)
      expect(white_bishop.valid_move? 5, 6).to eq(true)
      expect(white_bishop.valid_move? 2, 3).to eq(true)
      expect(white_bishop.valid_move? 2, 7).to eq(true)
      expect(white_bishop.valid_move? 6, 3).to eq(true)
      expect(white_bishop.valid_move? 6, 7).to eq(true)
    end
  end
end
