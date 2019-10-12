FactoryBot.define do
  factory :sharehouse, class: Post::ShareHouse do
    title { 'blablabl' }
    body  { 'blablabl' }
    available_from { Time.now.to_date }
    livings {1}
    rooms {2}
    toilets {1}
    tenants {1}
    property_type {0}
    user { create :wechat_user }
    rent { 2000 }
    payment_type { 0 }
    before :create do |post|
      file = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'assets', 'test.jpg'), 'image/jpg')
      post.attachments.attach file
      post.location = build :location
    end
  end
end
