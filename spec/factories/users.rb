FactoryBot.define do
  factory :user do
    username {'john'}
    gender {'0'}
    occupation {'程序员'}
    factory :web_user do
      password {'123458910'}
      phone { rand(10**11) } 
    end

    factory :wechat_user do
      sequence(:uid) { |n| "yinoF5krflF1n33LsoMU92&bsn#{n}"}
      provider {'wechat'}
      password {'1234568910'}
    end

    after :create do |user|
      create :location, target: user
    end
  end
end
