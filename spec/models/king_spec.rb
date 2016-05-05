require 'rails_helper'

RSpec.describe King, type: :model do
	let(:king) {create :king}

  describe "King's valid_move" do
  	it "should be inside destination, blocked" do
  		expect(king.valid_move?(1, 6)).to eq(false)
  		expect(king.valid_move?(1, 4)).to eq(false)
  		expect(king.valid_move?(2, 5)).to eq(false)
  	end

    it "shouldn't be outside destination" do
      expect(king.valid_move?(1, 8)).to eq(false)
      expect(king.valid_move?(1, 2)).to eq(false)
      expect(king.valid_move?(3, 8)).to eq(false)
    end

  	it "should be inside destination, not blocked" do
  		game = create :game
  		king2 = game.pieces.create(type: "King", rank: 4,  file: 5, color: "black")
  		expect(king2.valid_move?(4, 6)).to eq(true)
  		expect(king2.valid_move?(4, 4)).to eq(true)
  		expect(king2.valid_move?(5, 6)).to eq(true)
  	end
  end
end