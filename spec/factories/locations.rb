FactoryBot.define do
  factory :location do
    address { 'address' }
    name { 'name' }
    country
    province
    city
    suburb
    trait :with_geo do
      latitude { 80.021 }
      longitude { 120.23 }
    end
  end
end
