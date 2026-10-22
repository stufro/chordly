class AddTextSizeToUsers < ActiveRecord::Migration[8.2]
  def change
    add_column :users, :text_size, :string, default: "normal", null: false
  end
end
