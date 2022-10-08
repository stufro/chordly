class AddTrialUserIdToChordSheets < ActiveRecord::Migration[7.0]
  def change
    add_column :chord_sheets, :trial_user_id, :string
  end
end
