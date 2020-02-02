require 'rails_helper'

RSpec.describe NotificationsWorker, type: :model do
  describe '#perform' do
    before do
      @user = create :wechat_user
      @user1 = create :wechat_user
      chat_room = create :chat_room
      @c = create :conversation, chat_room_id: chat_room.id, user_id: @user.id
      @c1 = create :conversation, chat_room_id: chat_room.id, user_id: @user1.id
    end

    it 'should send message and create delivery log' do
      allow(ActionCable).to receive_message_chain("server.broadcast").and_return(1)
      Sidekiq::Testing.inline! do
        expect do
          create :message, conversation: @c1, body: 'hola', user_id: @user.id
        end.not_to raise_error
        expect(DeliveryLog.where(user_id: @user1.id).count).to eq 1
      end
    end

    it 'should not create delivery log if message cannot be deliveried' do
      allow(ActionCable).to receive_message_chain("server.broadcast").and_return(0)
      Sidekiq::Testing.inline! do
        expect do
          create :message, conversation: @c1, body: 'hola', user_id: @user.id
        end.not_to raise_error
        expect(DeliveryLog.where(user_id: @user1.id).count).to eq 0
      end
    end
  end
end
