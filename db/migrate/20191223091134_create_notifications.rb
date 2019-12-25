class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.bigint  :target_id
      t.string  :target_type
      t.integer :template_id
      t.integer :status
      t.timestamps
    end
  end
end
