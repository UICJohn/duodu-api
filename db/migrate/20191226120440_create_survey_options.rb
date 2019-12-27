class CreateSurveyOptions < ActiveRecord::Migration[6.1]
  def change
    create_table :survey_options do |t|
      t.integer :survey_id
      t.integer :position
      t.text :body
      t.boolean :custom_option, default: false
      t.timestamps
    end
  end
end
