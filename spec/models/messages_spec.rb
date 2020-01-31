require 'rails_helper'

RSpec.describe Message, type: :model do
  describe '#notifying_package' do
    before do
      @user = create :wechat_user
      @user1 = create :wechat_user
      @chat_room = create :chat_room
      @c = create :conversation, user_id: @user.id, chat_room_id: @chat_room.id
      create :conversation, user_id: @user1.id, chat_room_id: @chat_room.id
    end

    it 'should return correct data' do
      message = create :message, sender: @user, conversation: @c
      expect(message.notifying_package.key?(:body)).to eq true
      expect(message.notifying_package.key?(:tracer)).to eq true
      expect(message.notifying_package.key?(:user)).to eq true
      expect(message.notifying_package[:user].key?(:avatar)).to eq true
      expect(message.notifying_package[:user].key?(:id)).to eq true
    end

  end

  describe '#content_validator' do
    before do
      @user = create :wechat_user
      @chat_room = create :chat_room
      @c = create :conversation, user_id: @user.id, chat_room_id: @chat_room.id
    end

    it 'should return error' do
      @message = build :message, body: 'lalala', user_id: @user.id, conversation: @c, file: fixture_file_upload(Rails.root.join('spec', 'fixtures', 'assets', 'test.jpg'), 'image/jpg')
      expect(@message.valid?).to eq false
      expect(@message.errors.full_messages).to eq ["Invalid Message"]
    end
  end

  describe '#not_delivered' do

    before do
      @user = create :wechat_user
      @user1 = create :wechat_user
      @user2 = create :wechat_user
      @chat_room = create :chat_room
      @chat_room1 = create :chat_room
      @c1 = create :conversation, user_id: @user.id, chat_room_id: @chat_room.id
      @c2 = create :conversation, user_id: @user1.id, chat_room_id: @chat_room.id
      @c3 = create :conversation, user_id: @user1.id, chat_room_id: @chat_room1.id
      @c4 = create :conversation, user_id: @user2.id, chat_room_id: @chat_room1.id
    end

    it "should query message haven't delivered to user and room" do
      message = create :message, body: 'lalala2', sender: @user1, conversation: @c1
      create :message, body: 'lalala', sender: @user, conversation: @c1
      create :message, body: 'lalala1', sender: @user, conversation: @c1
      create :message, body: 'lalala3', sender: @user, conversation: @c1
      create :message, body: 'lalala4', sender: @user1, conversation: @c2
      create :message, body: 'lalala5', sender: @user2, conversation: @c4
      create :delivery_log, target: message, user: @user
      expect(Message.not_delivered(@user, @chat_room).count).to eq 1
      expect(Message.not_delivered(@user1, @chat_room).count).to eq 3
      expect(Message.not_delivered(@user1, @chat_room1).count).to eq 1
      expect(Message.not_delivered(@user2, @chat_room1).count).to eq 0
      expect(Message.not_delivered(@user, @chat_room1).count).to eq 0

    end
  end

  describe '#receivers' do
    before do
      @user = create :wechat_user
      @user1 = create :wechat_user
      @user2 = create :wechat_user
      @chat_room = create :chat_room
      @c1 = create :conversation, user_id: @user.id, chat_room_id: @chat_room.id
      create :conversation, user_id: @user1.id, chat_room_id: @chat_room.id
    end

    it 'should return correct receivers' do
      message = create :message, sender: @user, conversation: @c1
      expect(message.receivers).to include(@user1)
      expect(message.receivers.count).to eq 1
    end
  end

end
