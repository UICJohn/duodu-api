class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string  :title
      t.text    :body
      t.integer :post_type
      t.integer :property_id

      t.integer :range
      t.integer :min_rent
      t.integer :max_rent
      t.integer :rent
      t.integer :payment_type
      t.integer :user_id
      t.integer :lease_type
      t.integer :tenants
      t.datetime :available_from

      # houseinfo
      t.integer :livings
      t.integer :rooms
      t.integer :toilets
      t.integer :cover_image_id

      # condition
      t.boolean :has_sofa
      t.boolean :has_bed
      t.boolean :has_air_conditioner
      t.boolean :has_elevator
      t.boolean :has_washing_machine
      t.boolean :has_cook_top
      t.boolean :has_refregitor

      t.integer :tenants

      t.timestamps
    end
  end
end
