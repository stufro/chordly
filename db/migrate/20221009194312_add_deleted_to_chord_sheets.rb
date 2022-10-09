class AddDeletedToChordSheets < ActiveRecord::Migration[7.0]
  def change
    add_column :chord_sheets, :deleted, :boolean
  end
end
