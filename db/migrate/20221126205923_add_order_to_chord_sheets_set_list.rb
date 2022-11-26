class AddOrderToChordSheetsSetList < ActiveRecord::Migration[7.0]
  def change
    add_column :chord_sheets_set_lists, :order, :integer
  end
end
