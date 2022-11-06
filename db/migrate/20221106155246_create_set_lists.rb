class CreateSetLists < ActiveRecord::Migration[7.0]
  def change
    create_table :set_lists do |t|
      t.string :name

      t.timestamps
    end
  end
end
