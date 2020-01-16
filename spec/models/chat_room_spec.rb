require 'rails_helper'

RSpec.describe ChatRoom, type: :model do
  it 'should find private conversation for user1' do
    user = create :wechat_user
    user1 = create :wechat_user
    user2 = create :wechat_user
    user3 = create :wechat_user

    chat_room = create :chat_room
    chat_room1 = create :chat_room
    chat_room2 = create :chat_room

    create :conversation, chat_room: chat_room, user: user
    create :conversation, chat_room: chat_room, user: user1

    create :conversation, chat_room: chat_room1, user: user
    create :conversation, chat_room: chat_room1, user: user1
    create :conversation, chat_room: chat_room1, user: user2

    create :conversation, chat_room: chat_room2, user: user
    create :conversation, chat_room: chat_room2, user: user3

    expect(ChatRoom.private_room_for(user, user1)).to eq chat_room
  end

  it 'should create private conversation for user and user1' do
    user = create :wechat_user
    user1 = create :wechat_user
    user2 = create :wechat_user
    user3 = create :wechat_user

    chat_room = create :chat_room

    create :conversation, chat_room: chat_room, user: user
    create :conversation, chat_room: chat_room, user: user1
    create :conversation, chat_room: chat_room, user: user2

    expect{
      ChatRoom.private_room_for(user, user1)
    }.to change(ChatRoom, :count).by 1
  end
end
