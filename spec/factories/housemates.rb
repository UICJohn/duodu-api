FactoryBot.define do
  factory :housemate, class: Post::HouseMate do
    title { 'blablabl' }
    body  { 'blablabl' }
    available_from { Time.now.to_date }
    user { create :wechat_user }
  end
end
