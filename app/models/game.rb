class Game < ActiveRecord::Base
  validates :name, presence: true
  validates :white_player_id, presence: true
  validates :black_player_id, presence: true
  validates :state, presence: true, inclusion: {within: ["open", "white_in_check", "black_in_check", "white_in_mate", "black_in_mate", "draw"]}
  validate :players_must_be_different

  private
  def players_must_be_different
    errors.add(:base, "A game must have two different players") if white_player_id == black_player_id
  end
end
