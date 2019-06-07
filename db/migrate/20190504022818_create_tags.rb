class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.string :name
      t.integer :category_id
      t.timestamps
    end

    reversible do |dir|
      dir.up do
        Tag.create_translation_table! :name => :string
      end

      dir.down do
        Tag.drop_translation_table!
      end
    end

  end
end