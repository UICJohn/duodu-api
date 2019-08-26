class CreateSchools < ActiveRecord::Migration[5.2]
  def change
    create_table :schools do |t|
      t.string :name
      t.string :code
      t.string :department
      t.string :py
      t.timestamps
    end
  end
end
