FactoryBot.define do
  factory :suburb,  class: Region::Suburb do
    name { '惠城区' }
    city
  end
end