FactoryBot.define do
  factory :city,  class: Region::City do
    name { '惠州市' }
    province
  end
end