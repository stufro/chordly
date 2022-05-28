# frozen_string_literal: true

class CreateChordSheets < ActiveRecord::Migration[7.0]
  def change
    create_table :chord_sheets do |t|
      t.string :name
      t.jsonb :content
      t.timestamps
    end
  end
end
