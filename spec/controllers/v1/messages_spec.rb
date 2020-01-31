require 'rails_helper'
require 'devise/jwt/test_helpers'
require 'rake'
load File.join(Rails.root, 'lib', 'tasks', 'posts.rake')

RSpec.describe 'Messages', type: :request do
  before do
    @user = create :wechat_user
    @headers = Devise::JWT::TestHelpers.auth_headers({ 'Accept' => 'application/json' }, @user)
  end

  describe 'index' do
    before do
      @user1 = create :wechat_user
      @chat_room = create :chat_room
      @c1 = create :conversation, chat_room: @chat_room, user: @user
      @c2 = create :conversation, chat_room: @chat_room, user: @user1

      @chat_room1 = create :chat_room
      @c3 = create :conversation, chat_room: @chat_room1, user: @user1
      @c4 = create :conversation, chat_room: @chat_room1, user: (create :wechat_user)

      @message = create :message, user_id: @user1.id, conversation: @c2
      @message1 = create :message, user_id: @user.id, conversation: @c1
      create :message, user_id: @user1.id, conversation: @c2
      create :message, user_id: @user.id,  conversation: @c1
      create :message, user_id: @user1.id, conversation: @c2
    end

    it 'should return error' do
      expect {
        get '/v1/messages', params: { room_id: @chat_room1.id }, headers: @headers
      }.to change(DeliveryLog, :count).by 0

      expect(response).to be_successful

      response_body = JSON.parse(response.body)
      expect(response_body['error']).to eq 'Bad Request'
    end

    it 'should return all message and create delivery log' do
      create :message, user_id: @user1.id, conversation: @c3
      create :message, user_id: @user.id, conversation: @c1

      expect{
        get "/v1/messages", params: { room_id: @chat_room.id }, headers: @headers
      }.to change(DeliveryLog, :count).by(3)

      expect(response).to be_successful
      response_body = JSON.parse(response.body)
      expect(response_body['current_user']['id']).to eq @user.id
      expect(response_body['total_pages']).to eq 1
      expect(response_body['messages'].count).to eq 6
    end


    it 'should return all message and create delivery log only if delivery log does not exist' do
      create :delivery_log, target: @message, user: @user
      create :delivery_log, target: @message1, user: @user1

      expect{
        get "/v1/messages", params: { room_id: @chat_room.id }, headers: @headers
      }.to change(DeliveryLog, :count).by(2)

      expect(response).to be_successful
      response_body = JSON.parse(response.body)
      expect(response_body['current_user']['id']).to eq @user.id
      expect(response_body['total_pages']).to eq 1
      expect(response_body['messages'].count).to eq 5
    end
  end

end
