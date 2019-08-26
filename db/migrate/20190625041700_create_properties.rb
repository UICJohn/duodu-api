class CreateProperties < ActiveRecord::Migration[5.2]
  def change
    create_table :properties do |t|

      t.string  :country
      t.string  :province
      t.string  :city
      t.string  :address
      t.integer :unit
      t.integer :floor
      t.integer :number

      t.integer     :landlord_id
      # t.attachment  :certification
      # t.attachment  :identification
      t.boolean     :verified, default: false

      t.decimal :lng, precision: 10, scale: 6
      t.decimal :lat, precision: 10, scale: 6

      t.timestamps
    end
  end
end
