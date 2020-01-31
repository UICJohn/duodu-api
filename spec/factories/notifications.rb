FactoryBot.define do
  factory :notification do
    sender { create :wechat_user }
    template { create :notification_template }
    status { 0 }
  end
end
