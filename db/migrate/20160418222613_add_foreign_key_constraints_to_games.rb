class AddForeignKeyConstraintsToGames < ActiveRecord::Migration
  def change
    add_foreign_key :games, :users, column: :white_player_id
    add_foreign_key :games, :users, column: :black_player_id
  end
end
