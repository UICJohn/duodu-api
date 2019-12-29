FactoryBot.define do
  factory :user do
    username { 'john' }
    gender { 'male' }
    occupation { '程序员' }
    factory :web_user do
      password { '123458910' }
      phone { "1#{(1..10).map { rand(1..9) }.join}" }
    end

    factory :wechat_user do
      sequence(:uid) { |n| "yinoF5krflF1n33LsoMU92&bsn#{n}" }
      provider { 'wechat' }
      password { '1234568910' }
    end

    after :create do |user|
      # user.avatar.attach fixture_file_upload(Rails.root.join('spec', 'fixtures', 'assets', 'test.jpg'), 'image/jpg')
      create :location, :with_geo, target: user
    end
  end
end
