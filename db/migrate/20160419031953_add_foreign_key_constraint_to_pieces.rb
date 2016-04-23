class AddForeignKeyConstraintToPieces < ActiveRecord::Migration
  def change
    add_foreign_key :pieces, :games, on_delete: :cascade
  end
end
