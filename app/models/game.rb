class Game < ActiveRecord::Base
  validates :name, presence: true
  validates :state, presence: true, inclusion: {within: ["open", "white_in_check", "black_in_check", "white_in_mate", "black_in_mate", "draw"]}
  validate :at_least_one_player, :players_must_be_different

  has_many :pieces

  after_create :populate_board!

  private
  def at_least_one_player
    errors.add(:base, "A game must have at least one player") unless white_player_id.present? || black_player_id.present?
  end

  def players_must_be_different
    errors.add(:base, "A game cannot have the same user acting as both players") if white_player_id == black_player_id
  end

  def populate_board!
    #white_pieces
    (1..8).each do |i|
      Pawn.create(game_id: id, rank: 2, file: i, color: 'white')
    end
    
    Rook.create(game_id: id, rank: 1, file: 1, color: 'white')
    Knight.create(game_id: id, rank: 1, file: 2, color: 'white')
    Bishop.create(game_id: id, rank: 1, file: 3, color: 'white')
    Queen.create(game_id: id, rank: 1, file: 4, color: 'white')
    King.create(game_id: id, rank: 1, file: 5, color: 'white')
    Bishop.create(game_id: id, rank: 1, file: 6, color: 'white')
    Knight.create(game_id: id, rank: 1, file: 7, color: 'white')
    Rook.create(game_id: id, rank: 1, file: 8, color: 'white')

    #black_pieces
    (1..8).each do |i|
      Pawn.create(game_id: id, rank: 7, file: i, color: 'black')
    end

    Rook.create(game_id: id, rank: 8, file: 1, color: 'black')
    Knight.create(game_id: id, rank: 8, file: 2, color: 'black')
    Bishop.create(game_id: id, rank: 8, file: 3, color: 'black')
    Queen.create(game_id: id, rank: 8, file: 4, color: 'black')
    King.create(game_id: id, rank: 8, file: 5, color: 'black')
    Bishop.create(game_id: id, rank: 8, file: 6, color: 'black')
    Knight.create(game_id: id, rank: 8, file: 7, color: 'black')
    Rook.create(game_id: id, rank: 8, file: 8, color: 'black')
      
  end
end
