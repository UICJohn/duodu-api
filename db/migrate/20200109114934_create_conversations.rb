class CreateConversations < ActiveRecord::Migration[6.1]
  def change
    create_table :conversations do |t|
      t.references :user
      t.references :chat_room
      t.timestamps
    end

    add_index :conversations, [:user_id, :chat_room_id]

    add_index :conversations, [:chat_room_id, :user_id]
  end
end
