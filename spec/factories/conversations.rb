FactoryBot.define do
  factory :conversation do
    chat_room
    user { create :wechat_user }
  end
end
