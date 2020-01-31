FactoryBot.define do
  factory :message do
    body  { 'blablabl' }
    sender { create :wechat_user }
    conversation { create :conversation}
  end
end
