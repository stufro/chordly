class ChangeContentColumnToText < ActiveRecord::Migration[7.2]
  def up
    change_column :chord_sheets, :content, :text
  end

  def down
    change_column :chord_sheets, :content, :jsonb
  end
end
