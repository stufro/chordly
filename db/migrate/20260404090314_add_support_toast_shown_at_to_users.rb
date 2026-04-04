class AddSupportToastShownAtToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :support_toast_shown_at, :datetime
  end
end
