class DropAdminColumnFromUsers < ActiveRecord::Migration[7.2]
  def change
    remove_column :users, :admin, :boolean
  end
end
