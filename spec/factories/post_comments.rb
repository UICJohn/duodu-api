FactoryBot.define do
  factory :post_comment, class: Comment do
    body  { 'blablabl' }
    user { create :wechat_user }
  end
end
