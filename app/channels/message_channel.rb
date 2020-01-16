class MessageChannel < ApplicationCable::Channel
  def subscribed
    stream_from "messages_#{current_user.id}"
  end

  def send_message(data)
    package = JSON.load(data['message'])
    if package['room_id'].present? && chat_room = current_user.chat_rooms.find_by(id: package['room_id'])
      current_user.messages.create(body: package['body'], chat_room_id: chat_room.id)
    else
      ActionCable.server.broadcast("messages_#{current_user.id}", message: 'Invalid Message')
    end
  end
end