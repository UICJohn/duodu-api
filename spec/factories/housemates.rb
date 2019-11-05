FactoryBot.define do
  factory :housemate, class: Post::HouseMate do
    title { 'blablabl' }
    body  { 'blablabl' }
    available_from { Time.zone.now.to_date }
    user { create :wechat_user }
    before :create do |post|
      post.locations << build(:location_with_regions)
    end
  end
end
