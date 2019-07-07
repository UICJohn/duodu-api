class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string  :title
      t.text    :body
      t.integer :type
      t.integer :property_id
      t.string  :address
      t.string  :province
      t.string  :city
      t.string  :suburb
      t.integer :user_id
      t.string  :phone_number
      t.boolean :draft, default: true
      t.boolean :take

      t.timestamps
    end
  end
end
