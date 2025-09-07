class AddCreatedFromChordproToChordSheets < ActiveRecord::Migration[7.2]
  def change
    add_column :chord_sheets, :created_from_chord_pro, :boolean
  end
end
