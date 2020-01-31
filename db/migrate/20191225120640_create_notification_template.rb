class CreateNotificationTemplate < ActiveRecord::Migration[6.1]
  def change
    create_table :notification_templates do |t|
      t.string :code
      t.string :title
      t.text   :body
      t.timestamps
    end
  end
end
