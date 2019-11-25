class CreateSubways < ActiveRecord::Migration[5.2]
  def change
    create_table :subways do |t|
      t.string :name
      t.string :source_id
      t.timestamps
    end

    add_index :subways, :source_id, using: :btree
  end
end
