class CreateWarehouseDateDimensions < ActiveRecord::Migration[6.1]
  def change
    create_table :warehouse_date_dimensions do |t|
      t.date :date
      t.timestamps
    end
  end
end
