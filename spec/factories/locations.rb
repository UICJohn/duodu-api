FactoryBot.define do
  factory :location do
    country
    province
    city
    suburb
    latitude { 143.021 }
    longitude { 120.23 }
  end
end
