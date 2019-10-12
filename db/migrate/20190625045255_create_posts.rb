class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string  :type

      # Attributes
      t.string  :title
      t.text    :body
      t.integer :payment_type
      t.integer :user_id
      t.datetime :available_from
      t.integer :rent
      t.integer :livings
      t.integer :rooms
      t.integer :toilets
      t.integer :cover_image_id
      t.integer :property_type

      t.integer :tenants
      t.integer :tenants

      # condition
      t.boolean :has_furniture,       default: false
      t.boolean :has_appliance,       default: false
      t.boolean :has_network,         default: false
      t.boolean :has_air_conditioner, default: false
      t.boolean :has_elevator,        default: false
      t.boolean :has_cook_top,        default: false
      t.boolean :has_pets,            default: false

      # requirement
      t.boolean :pets_allow, default: false
      t.boolean :smoke_allow, default: false
      t.integer :tenants_gender, default: 2
      t.integer :area_ids, array: true, default: []
      t.integer :min_rent, default: 0
      t.integer :max_rent, default: 0

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
