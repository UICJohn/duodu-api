class CreateUserSurveys < ActiveRecord::Migration[6.1]
  def change
    create_table :user_surveys do |t|
      t.integer :user_id
      t.integer :survey_id
      t.integer :survey_option_id
      t.text    :body
      t.integer :target_id
      t.string  :target_type
      t.timestamps
    end
  end
end
