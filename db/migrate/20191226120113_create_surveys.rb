class CreateSurveys < ActiveRecord::Migration[6.1]
  def change
    create_table :surveys do |t|
      t.text    :body
      t.string  :title
      t.string  :code_name
      t.timestamps
    end
  end
end
