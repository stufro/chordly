class CreateLineStyles < ActiveRecord::Migration[8.2]
  def change
    create_table :line_styles do |t|
      t.references :styleable, polymorphic: true, null: false, index: false
      t.string :line_type, null: false
      t.string :font_style, null: false
      t.string :colour

      t.timestamps
    end

    add_index :line_styles, %i[styleable_type styleable_id line_type], unique: true
  end
end
