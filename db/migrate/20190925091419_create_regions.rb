class CreateRegions < ActiveRecord::Migration[5.2]
  def change
    create_table :regions do |t|

      t.string :type

      t.string  :code
      t.string  :baidu_id
      t.string  :tencent_id
      t.integer :parent_id
      t.string  :pinyin

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        Region::Base.create_translation_table! :name => :string
      end

      dir.down do
        Region::Base.drop_translation_table!
      end
    end

    add_index :regions, :tencent_id, using: :btree
    add_index :regions, :baidu_id, using: :btree
    add_index :regions, :parent_id, using: :btree
    add_index :regions, :pinyin, using: :btree
    add_index :regions, :type, using: :btree
  end
end
