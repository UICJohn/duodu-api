class CreateWarehousePostFacts < ActiveRecord::Migration[6.1]
  def change
    create_table :warehouse_post_facts do |t|
      t.integer :post_id
      t.integer :user_id
      t.integer :date_id
      t.integer :action
      t.timestamps
    end
  end
end
