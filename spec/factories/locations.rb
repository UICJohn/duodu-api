FactoryBot.define do
  factory :location do
    country {'CN'}
    province {'guangdong'}
    city {'huizhou'}
    suburb {'huicheng'}
    latitude { 143.021 }
    longitude { 120.23 }
  end
end