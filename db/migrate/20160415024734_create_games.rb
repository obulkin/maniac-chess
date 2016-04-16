class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name, null: false
      t.integer :white_player_id
      t.integer :black_player_id
      t.boolean :white_can_castle, default: false, null: false
      t.boolean :black_can_castle, default: false, null: false
      t.boolean :white_to_move, default: true, null: false
      t.string :state, null: false
      t.timestamps null: false
    end

    add_index :games, [:white_player_id, :state]
    add_index :games, [:black_player_id, :state]
  end
end
