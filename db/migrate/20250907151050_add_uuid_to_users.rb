class AddUuidToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :uuid, :string
  end
end
