class Game < ActiveRecord::Base
  validates :name, presence: true
  validates :state, presence: true, inclusion: {within: ["open", "white_in_check", "black_in_check", "white_in_mate", "black_in_mate", "draw"]}
  validate :at_least_one_player, :players_must_be_different

  belongs_to :white_player, class_name: "User"
  belongs_to :black_player, class_name: "User"

  private
  def at_least_one_player
    errors.add(:base, "A game must have at least one player") unless white_player_id.present? || black_player_id.present?
  end

  def players_must_be_different
    errors.add(:base, "A game cannot have the same user acting as both players") if white_player_id == black_player_id
  end
end
