FactoryBot.define do
  factory :country,  class: Region::Country do
    name { '中国' }
  end
end