FactoryBot.define do
  factory :takehouse, class: Post::TakeHouse do
    title { 'blablabl' }
    body  { 'blablabl' }
    available_from { Time.zone.now.to_date }
    livings { 1 }
    rooms { 2 }
    toilets { 1 }
    property_type { 0 }
    payment_type { 0 }
    user { create :wechat_user }
    rent { 2000 }
    before :create do |post|
      post.location = build :location, :with_geo
    end
  end
end
