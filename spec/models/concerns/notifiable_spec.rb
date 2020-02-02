require 'rails_helper'

RSpec.describe Notifiable do

  before do
    @user = create :wechat_user
    @user1 = create :wechat_user
    @chat_room = create :chat_room
    @c = create :conversation, user_id: @user.id, chat_room_id: @chat_room.id
    @c1 = create :conversation, user_id: @user1.id, chat_room_id: @chat_room.id
  end

  describe 'notify' do
    it 'should notify after create' do
      Sidekiq::Testing.fake!
      expect {
        create :message, conversation: @c1, user_id: @user.id
      }.to change(NotificationsWorker.jobs, :size).by(1)
    end
  end

  describe '#channel_prefix' do
    it 'should return default prefix' do
      message = create :message, conversation: @c, user_id: @user.id
      expect(message.channel_prefix).to eq "messages"
    end
  end
end
