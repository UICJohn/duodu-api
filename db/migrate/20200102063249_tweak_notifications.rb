class TweakNotifications < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :sender_id, :integer
    rename_column :notifications, :user_id, :receiver_id
  end
end
