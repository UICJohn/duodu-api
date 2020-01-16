class CreateDeliveryLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :delivery_logs do |t|
      t.bigint :target_id
      t.string :target_type
      t.integer :user_id
      t.integer :delivery_method
      t.timestamps
    end
  end
end
