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
      t.attachment  :certification
      t.attachment  :identification
      t.boolean     :verified, default: false

      t.decimal :lng, precision: 10, scale: 6
      t.decimal :lat, precision: 10, scale: 6


      # t.boolean :has_wifi, default: false
      # t.boolean :has_furniture, default: false
      # t.boolean :has_air_conditioner, default: false

      t.boolean :has_elevator, default: false
      t.boolean :available, default: true

      t.timestamps
    end
  end
end
