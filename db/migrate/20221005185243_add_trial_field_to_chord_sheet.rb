class AddTrialFieldToChordSheet < ActiveRecord::Migration[7.0]
  def change
    add_column :chord_sheets, :trial, :boolean
  end
end
