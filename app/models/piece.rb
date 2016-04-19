class Piece < ActiveRecord::Base
  validates :type, presence: true, inclusion: {within: ["Pawn", "Rook", "Bishop", "Knight", "Queen", "King"]}
  validates :color, presence: true, inclusion: {within: ["white", "black"]}
  validates :rank, presence: true, inclusion: {within: 1..8}
  validates :file, presence: true, inclusion: {within: 1..8}
  validates :game_id, presence: true

  belongs_to :game
end
