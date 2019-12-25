FactoryBot.define do
  factory :comment, class: Comment do
    body  { 'blablabl' }
    user { create :wechat_user }
  end
end
