class TweakNotificationTemplate < ActiveRecord::Migration[6.1]
  def change
    add_column :notification_templates, :code, :string
    remove_column :notification_templates, :tag
  end
end
