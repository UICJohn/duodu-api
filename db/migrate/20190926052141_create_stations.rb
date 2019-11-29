class CreateStations < ActiveRecord::Migration[5.2]
  def change
    create_table :stations do |t|
      t.string  :name
      t.string  :source_id
      t.boolean :active, default: true
      t.timestamps
    end
  end
end
