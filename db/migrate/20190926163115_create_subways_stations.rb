class CreateSubwaysStations < ActiveRecord::Migration[5.2]
  def change
    create_join_table :subways, :stations do |t|
      t.index [:subway_id, :station_id]
    end
  end
end
