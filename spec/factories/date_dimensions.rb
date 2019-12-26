FactoryBot.define do
  factory :warehouse_date_dimension, class: Warehouse::DateDimension do
    date { Time.now.to_date }
  end
end
