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
      json.id message.user.id
      json.avatar message.user.avatar.url if message.user.avatar.attached?
    end
    json.body message.body
    json.tracer message.tracer
  end
end