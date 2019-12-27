FactoryBot.define do
  factory :user_survey do
    user { create :wechat_user }
    body { 'survey' }   
  end
end
