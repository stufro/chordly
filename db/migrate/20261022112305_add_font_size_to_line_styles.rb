class AddFontSizeToLineStyles < ActiveRecord::Migration[8.2]
  def change
    add_column :line_styles, :font_size, :string
  end
end
