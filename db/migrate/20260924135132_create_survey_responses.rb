class CreateSurveyResponses < ActiveRecord::Migration[8.2]
  def change
    create_table :survey_responses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :survey_key, null: false
      t.json :answers, null: false, default: {}
      t.datetime :completed_at
      t.datetime :dismissed_at

      t.timestamps
    end

    add_index :survey_responses, %i[user_id survey_key], unique: true
  end
end
