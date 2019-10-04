class CreateSubways < ActiveRecord::Migration[5.2]
  def change
    create_table :subways do |t|
      t.string :source_id
      t.timestamps
    end

    add_index :subways, :source_id, using: :btree

    reversible do |dir|
      dir.up do
        Subway.create_translation_table! :name => :string
      end

      dir.down do
        Subway.drop_translation_table!
      end
    end
  end
end
