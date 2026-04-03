class AddSupportToastToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :support_toast_dismissed_at, :datetime
    add_column :users, :support_toast_clicked_at, :datetime
  end
end
