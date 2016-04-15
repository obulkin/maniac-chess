class Game < ActiveRecord::Base
  validates :name, presence: true
  validates :white_player_id, presence: true
  validates :black_player_id, presence: true
  validates :state, presence: true, inclusion: {within: ["open", "white_in_check", "black_in_check", "white_in_mate", "black_in_mate", "draw"]}
end
