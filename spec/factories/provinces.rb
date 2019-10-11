FactoryBot.define do
  factory :province, class: Region::Province do
    name { '广东省' }
    country
  end
end
