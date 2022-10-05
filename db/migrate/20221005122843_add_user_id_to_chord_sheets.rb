class AddUserIdToChordSheets < ActiveRecord::Migration[7.0]
  def change
    add_column :chord_sheets, :user_id, :integer
    add_index :chord_sheets, :user_id
  end
end
