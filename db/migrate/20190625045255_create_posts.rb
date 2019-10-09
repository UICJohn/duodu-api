class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string  :title
      t.text    :body
      t.integer :property_id

      t.integer :range
      t.integer :min_rent
      t.integer :max_rent
      t.integer :rent
      t.integer :payment_type
      t.integer :user_id
      t.integer :tenants
      t.datetime :available_from
      t.string  :type

      # houseinfo
      t.integer :livings
      t.integer :rooms
      t.integer :toilets
      t.integer :cover_image_id

      # condition
      t.boolean :has_furniture
      t.boolean :has_appliance
      t.boolean :has_air_conditioner
      t.boolean :has_elevator
      t.boolean :has_cook_top

      t.integer :tenants

      t.timestamps
    end

    add_index :posts, :type, using: :btree
    add_index :posts, :rent, using: :btree
    add_index :posts, :tenants, using: :btree
    add_index :posts, :rooms, using: :btree
    add_index :posts, :livings, using: :btree
    add_index :posts, :toilets, using: :btree
    add_index :posts, :user_id, using: :btree
  end
end
