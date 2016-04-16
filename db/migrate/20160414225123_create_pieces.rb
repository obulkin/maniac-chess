class CreatePieces < ActiveRecord::Migration
  def change
    create_table :pieces do |t|
      t.string :type, null: false
      t.string :color, null: false
      t.integer :rank, null: false
      t.integer :file, null: false
      t.integer :game_id, null: false
      t.boolean :en_passant, default: false, null: false
      t.timestamps null: false
    end

    add_index :pieces, [:game_id, :color]
    add_index :pieces, [:game_id, :type]
  end
end
