class AddTwoColumnsToChordSheets < ActiveRecord::Migration[8.2]
  def change
    add_column :chord_sheets, :two_columns, :boolean, default: false, null: false
  end
end
