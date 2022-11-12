class ChordSheetsBelongToSetLists < ActiveRecord::Migration[7.0]
  def change
    create_join_table :chord_sheets, :set_lists
  end
end
