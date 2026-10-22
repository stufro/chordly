class AddTextSizeToChordSheets < ActiveRecord::Migration[8.2]
  def change
    add_column :chord_sheets, :text_size, :string, default: "normal", null: false
  end
end
