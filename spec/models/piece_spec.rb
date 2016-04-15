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
  end
end
