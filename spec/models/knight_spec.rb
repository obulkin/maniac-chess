require 'rails_helper'

RSpec.describe Knight, type: :model do
  describe "#valid_move?" do
    let(:game) {create :game}

    it "should correctly evaluate malformed moves, including ones that are otherwise valid" do
      white_knight = game.pieces.find_by rank: 1, file: 2
      black_knight = game.pieces.find_by rank: 8, file: 7
      expect(white_knight.valid_move? 1, 2).to eq(false)
      expect(white_knight.valid_move? 0, 0).to eq(false)
      expect(white_knight.valid_move? 0, 4).to eq(false)
      expect(white_knight.valid_move? 2, 0).to eq(false)
      expect(black_knight.valid_move? 9, 9).to eq(false)
      expect(black_knight.valid_move? 9, 5).to eq(false)
      expect(black_knight.valid_move? 7, 9).to eq(false)
    end

    it "should correctly evaluate obstructed moves, including ones that are otherwise valid" do
      white_knight = create :knight, rank: 3, file: 5, game: game
      black_knight = create :knight, rank: 6, file: 5, color: "black", game: game
      expect(white_knight.valid_move? 2, 7).to eq(false)
      expect(white_knight.valid_move? 2, 3).to eq(false)
      expect(white_knight.valid_move? 1, 6).to eq(false)
      expect(white_knight.valid_move? 1, 4).to eq(false)
      expect(black_knight.valid_move? 7, 7).to eq(false)
      expect(black_knight.valid_move? 7, 3).to eq(false)
      expect(black_knight.valid_move? 8, 6).to eq(false)
      expect(black_knight.valid_move? 8, 4).to eq(false)
    end

    it "should correctly evaluate unobstructed, well-formed moves that a knight can't make" do
      white_knight = create :knight, rank: 4, file: 5, game: game
      expect(white_knight.valid_move? 4, 4).to eq(false)
      expect(white_knight.valid_move? 4, 6).to eq(false)
      expect(white_knight.valid_move? 3, 4).to eq(false)
      expect(white_knight.valid_move? 3, 5).to eq(false)
      expect(white_knight.valid_move? 3, 6).to eq(false)
      expect(white_knight.valid_move? 6, 3).to eq(false)
      expect(white_knight.valid_move? 6, 5).to eq(false)
      expect(white_knight.valid_move? 6, 7).to eq(false)
      expect(white_knight.valid_move? 6, 8).to eq(false)
      expect(white_knight.valid_move? 6, 2).to eq(false)
    end

    it "should correctly evaluate proper knight moves" do
      white_knight = create :knight, rank: 4, file: 5, game: game
      black_knight = create :knight, rank: 5, file: 5, color: "black", game: game
      expect(white_knight.valid_move? 5, 7).to eq(true)
      expect(white_knight.valid_move? 5, 3).to eq(true)
      expect(white_knight.valid_move? 6, 6).to eq(true)
      expect(white_knight.valid_move? 6, 4).to eq(true)
      expect(black_knight.valid_move? 4, 7).to eq(true)
      expect(black_knight.valid_move? 4, 3).to eq(true)
      expect(black_knight.valid_move? 3, 6).to eq(true)
      expect(black_knight.valid_move? 3, 4).to eq(true)
    end
  end
end
