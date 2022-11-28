class AddDeletedToSetLists < ActiveRecord::Migration[7.0]
  def change
    add_column :set_lists, :deleted, :boolean
  end
end
