json.room do
  chat_room_users = @room.users.where.not(id: current_user.id)
  if chat_room_users.count > 1
    json.title "群聊"
  else
    json.title "#{chat_room_users.first.username}"
  end
end

json.current_user do
  json.id current_user.id
  json.avatar current_user.avatar.url
end


json.total_pages @messages.total_pages
json.page @messages.current_page

json.messages do
  json.array! @messages.sort do |message|
    json.id message.id
    json.user do
      json.id message.sender.id
      json.avatar message.sender.avatar.url if message.sender.avatar.attached?
    end
    json.body message.body
    json.tracer message.tracer
  end
end