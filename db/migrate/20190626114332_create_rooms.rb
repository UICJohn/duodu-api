class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.references :property, foreign_key: true
      t.string  :title
      t.text    :body
      t.integer :parent_id
      t.string  :parent_type
      t.boolean :has_bathroom, default: false
      t.boolean :has_windows, default: false
      t.boolean :has_furniture, default: false
      t.boolean :has_air_conditioner, default: false
      t.boolean :available

      t.timestamps
    end
  end
end
