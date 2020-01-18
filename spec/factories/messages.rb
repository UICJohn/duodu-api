FactoryBot.define do
  factory :message do
    body  { 'blablabl' }
    user { create :wechat_user }
    chat_room { create :chat_room}
  end
end
