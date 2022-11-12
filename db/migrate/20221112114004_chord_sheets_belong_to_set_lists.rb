class ChordSheetsBelongToSetLists < ActiveRecord::Migration[7.0]
  def change
    create_join_table :chord_sheets, :set_lists

    add_index :chord_sheets_set_lists, :set_list_id
    add_index :chord_sheets_set_lists, :chord_sheet_id
  end
end
