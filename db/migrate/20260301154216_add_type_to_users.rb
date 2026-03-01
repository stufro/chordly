class AddTypeToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :user_type, :string, default: "standard", null: false
  end
end
