class CreateStations < ActiveRecord::Migration[5.2]
  def change
    create_table :stations do |t|
      t.string  :source_id
      t.boolean :active, default: true
      t.timestamps
    end
    reversible do |dir|
      dir.up do
        Station.create_translation_table! :name => :string
      end

      dir.down do
        Station.drop_translation_table!
      end
    end
  end
end
