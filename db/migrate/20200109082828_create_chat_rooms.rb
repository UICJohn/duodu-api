class CreateChatRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :chat_rooms do |t|      
      t.boolean :private, default: true
      t.timestamps
    end
  end
end
