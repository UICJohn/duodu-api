class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.integer :country_id
      t.integer :province_id
      t.integer :city_id
      t.integer :suburb_id
      t.string :name
      t.string :address
      t.decimal :longitude, precision: 10, scale: 6
      t.decimal :latitude, precision: 10, scale: 6
      t.bigint  :target_id
      t.string  :target_type
      # t.boolean :active
    end

    add_index :locations, :country_id, using: :btree
    add_index :locations, :province_id, using: :btree
    add_index :locations, :city_id, using: :btree
    add_index :locations, :suburb_id, using: :btree
  end
end
