class AddForeignKeyConstraintsToGames < ActiveRecord::Migration
  def change
    add_foreign_key :games, :users, column: :white_player_id, on_delete: :cascade
    add_foreign_key :games, :users, column: :black_player_id, on_delete: :cascade
  end
end
