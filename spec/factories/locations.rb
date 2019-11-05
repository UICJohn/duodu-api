FactoryBot.define do
  factory :location do
    latitude { 80.021 }
    longitude { 120.23 }
    factory :location_with_regions do
      country
      province
      city
      suburb
    end
  end
end
