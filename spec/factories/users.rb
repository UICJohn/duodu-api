FactoryBot.define do
  factory :user do
    username {'john'}
    gender {'0'}
    occupation {'程序员'}

    factory :web_user do
      password {'123458910'}
      phone {'17283819201'}
    end

    factory :wechat_user do
      uid {'yinoF5krflF1n33LsoMU92&bsnJs'}
      provider {'wechat'}
      password {'1234568910'}
    end
  end
end
