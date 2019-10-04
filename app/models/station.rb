class Station < ApplicationRecord
  translates :name


  has_and_belongs_to_many :subways
  has_one  :location, as: :target

  # validates_uniqueness_of :name, scope: :city_id

end