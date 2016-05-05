require 'rails_helper'

RSpec.describe King, type: :model do
  
  describe "King's valid_move" do
  	it "should be inside destination, blocked" do
      game = create :game
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

    it "shouldn't be outside destination" do
      game = create :game
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

  	it "should be inside destination, not blocked" do
  		game = create :game
  		king2 = game.pieces.create(type: "King", rank: 4,  file: 5, color: "black")
  		expect(king2.valid_move?(4, 6)).to eq(true)
  		expect(king2.valid_move?(4, 4)).to eq(true)
      expect(king2.valid_move?(5, 5)).to eq(true)
      expect(king2.valid_move?(3, 5)).to eq(true)
      expect(king2.valid_move?(5, 4)).to eq(true)
  		expect(king2.valid_move?(5, 6)).to eq(true)
      expect(king2.valid_move?(3, 4)).to eq(true)
      expect(king2.valid_move?(3, 6)).to eq(true)
  	end

    it "shouldn't be on same square after moving" do
      game = create :game
      king = game.pieces.find_by(rank: 1, file: 5, color: "white")
      expect(king.valid_move?(1, 5)).to eq(false)
    end

  end
end