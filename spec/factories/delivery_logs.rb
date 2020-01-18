FactoryBot.define do
  factory :delivery_log do
    target {create :message}
    user { create :wechat_user }
  end
end
