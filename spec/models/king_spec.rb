require 'rails_helper'

RSpec.describe King, type: :model do
  let(:game) {create :game}
  
  describe "King's valid_move" do
    it "should properly evaluate blocked moves that are otherwise valid" do
      king = game.pieces.find_by(rank: 1, file: 5, color: "white")
      king2 = game.pieces.find_by(rank: 8, file: 5, color: "black")
      expect(king.valid_move?(1, 6)).to eq(false)
      expect(king.valid_move?(1, 4)).to eq(false)
      expect(king.valid_move?(2, 5)).to eq(false)
      expect(king.valid_move?(2, 4)).to eq(false)
      expect(king.valid_move?(2, 6)).to eq(false)
      expect(king2.valid_move?(7, 5)).to eq(false)
      expect(king2.valid_move?(7, 4)).to eq(false)
      expect(king2.valid_move?(7, 6)).to eq(false)
    end

    it "shouldn properly evaluate moves that are not allowed for a king but are otherwise valid" do
      king1 = game.pieces.create(type: "King", rank: 3, file: 6, color: "white")
      king2 = game.pieces.create(type: "King", rank: 6, file: 3, color: "black")
      expect(king1.valid_move?(5, 6)).to eq(false)
      expect(king1.valid_move?(3, 4)).to eq(false)
      expect(king1.valid_move?(3, 8)).to eq(false)
      expect(king1.valid_move?(5, 4)).to eq(false)
      expect(king1.valid_move?(5, 8)).to eq(false)
      expect(king2.valid_move?(4, 3)).to eq(false)
      expect(king2.valid_move?(4, 1)).to eq(false)
      expect(king2.valid_move?(4, 5)).to eq(false)
    end

    it "should properly evaluate valid moves" do
      king2 = game.pieces.create(type: "King", rank: 4, file: 5, color: "black")
      expect(king2.valid_move?(4, 6)).to eq(true)
      expect(king2.valid_move?(4, 4)).to eq(true)
      expect(king2.valid_move?(5, 5)).to eq(true)
      expect(king2.valid_move?(3, 5)).to eq(true)
      expect(king2.valid_move?(5, 4)).to eq(true)
      expect(king2.valid_move?(5, 6)).to eq(true)
      expect(king2.valid_move?(3, 4)).to eq(true)
      expect(king2.valid_move?(3, 6)).to eq(true)
    end

    it "should properly evaluate that a king shouldn't stay on same square after moves" do
      king = game.pieces.find_by(rank: 1, file: 5, color: "white")
      expect(king.valid_move?(1, 5)).to eq(false)
    end

    it "should properly evaluate moves that take a king outside the board but are otherwise valid" do
      king = game.pieces.find_by(rank: 1, file: 5, color: "white")
      king2 = game.pieces.find_by(rank: 8, file: 5, color: "black")
      king3 = game.pieces.create(type: "King", rank: 4, file: 8, color: "white")
      king4 = game.pieces.create(type: "King", rank: 5, file: 1, color: "black")
      expect(king.valid_move?(0, 5)).to eq(false)
      expect(king.valid_move?(0, 4)).to eq(false)
      expect(king.valid_move?(0, 6)).to eq(false)
      expect(king2.valid_move?(9, 5)).to eq(false)
      expect(king2.valid_move?(9, 4)).to eq(false)
      expect(king2.valid_move?(9, 6)).to eq(false)
      expect(king3.valid_move?(4, 9)).to eq(false)
      expect(king3.valid_move?(5, 9)).to eq(false)
      expect(king3.valid_move?(3, 9)).to eq(false)
      expect(king4.valid_move?(5, 0)).to eq(false)
      expect(king4.valid_move?(6, 0)).to eq(false)
      expect(king4.valid_move?(4, 0)).to eq(false)
    end

  end
end