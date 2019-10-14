class CreatePreference < ActiveRecord::Migration[5.2]
  def change
    create_table :preferences do |t|
      t.boolean :show_privacy_data, default: false
      t.boolean :share_location, default: false
      t.boolean :receive_all_message, default: true
      t.references :user
      t.timestamps
    end
  end
end
