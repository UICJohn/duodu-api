require 'rails_helper'

RSpec.describe DeliveryLog, type: :model do
  describe '#self_message?' do
    before do
      @user = create :wechat_user
      @user1 = create :wechat_user
      chat_room = create :chat_room
      c1 = create :conversation, user: @user, chat_room: chat_room
      c2 = create :conversation, user: @user1, chat_room: chat_room
      @message = create :message, sender: @user, conversation: c1
      @message1 = create :message, sender: @user1, conversation: c2
    end

    it 'should return true and halt creation' do
      log = DeliveryLog.create(target: @message, user: @user)
      expect(log.valid?).to eq false
      expect(log.errors.full_messages).to eq ["try to create delivery log for self message"]
    end

    it 'should return false and pass the validation' do
      log = DeliveryLog.create(target: @message1, user: @user)
      expect(log.send(:self_message?)).to eq nil
    end
  end
end
