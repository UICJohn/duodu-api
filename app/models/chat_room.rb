class ChatRoom < ApplicationRecord
  has_many :messages
  has_many :conversations
  has_many :users, through: :conversations

  def self.private_room_for(u1, u2)
    room_id = Conversation.select('chat_room_id').group('chat_room_id').having("array_agg(user_id ORDER BY user_id ASC) = ?", "{#{[u1.id, u2.id].sort.join(',')}}").pluck('distinct chat_room_id')
    room_id.blank? ? self.create_private_room_for(u1, u2) : ChatRoom.find_by(id: room_id)
  end

  private

  def self.create_private_room_for(u1, u2)
    room = ChatRoom.create
    Conversation.create user_id: u1.id, chat_room_id: room.id
    Conversation.create user_id: u2.id, chat_room_id: room.id
    room
  end
end
