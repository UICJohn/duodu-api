FactoryBot.define do
  factory :housemate,  class: Post::Housemate do
    title {'blablabl'}
    body  {'blablabl'}
    available_from {Time.now.to_date}
    range { 0 }
    user {create :wechat_user}
    before :create do |post|
      post.location = build :location
    end
  end
end