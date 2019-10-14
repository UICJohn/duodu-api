FactoryBot.define do
  factory :takehouse, class: Post::TakeHouse do
    title { 'blablabl' }
    body  { 'blablabl' }
    available_from { Time.now.to_date }
    livings {1}
    rooms {2}
    toilets {1}
    property_type {0}
    payment_type { 0 }
    user { create :wechat_user }
    rent { 2000 }
    before :create do |post|
      # post.attachments.attach fixture_file_upload(Rails.root.join('spec', 'fixtures', 'assets', 'test.jpg'), 'image/jpg')
      post.location = build :location
    end
  end
end
