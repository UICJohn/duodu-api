class Warehouse::DateDimension < ApplicationRecord
  include Warehouse

  def self.find_dimension_for(date)
    date_dimension = first_or_create(date: date.to_date)
  end
end