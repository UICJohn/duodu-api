class MessageChannel < ApplicationCable::Channel
  def subscribed
    stream_from "messages_#{current_user.id}"
  end

  def send_message(data)
    package = JSON.load(data['message'])
    if package['room_id'].present? && conversation = current_user.conversations.find_by(chat_room_id: package['room_id'])
      current_user.messages.create(body: package['body'], conversation_id: conversation.id)
    else
      ActionCable.server.broadcast("messages_#{current_user.id}", message: 'Invalid Message')
    end
  end
end