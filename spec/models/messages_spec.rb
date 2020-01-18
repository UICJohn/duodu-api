require 'rails_helper'

RSpec.describe Message, type: :model do
  describe '#notifying_package' do
    before do
      @user = create :wechat_user
      @user1 = create :wechat_user
      @chat_room = create :chat_room
      create :conversation, user_id: @user.id, chat_room_id: @chat_room.id
      create :conversation, user_id: @user1.id, chat_room_id: @chat_room.id
    end

    it 'should return correct data' do
      message = create :message, user_id: @user.id, chat_room_id: @chat_room.id      
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
      create :conversation, user_id: @user.id, chat_room_id: @chat_room.id
    end

    it 'should return error' do
      @message = build :message, body: 'lalala', user_id: @user.id, chat_room_id: @chat_room.id, file: fixture_file_upload(Rails.root.join('spec', 'fixtures', 'assets', 'test.jpg'), 'image/jpg')
      expect(@message.valid?).to eq false
      expect(@message.errors.full_messages).to eq ["Invalid Message"]
    end
  end

end
