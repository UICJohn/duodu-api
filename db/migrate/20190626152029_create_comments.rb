class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.bigint  :target_id
      t.string  :target_type
      t.integer :user_id
      t.text :body

      t.timestamps
    end
  end
end
