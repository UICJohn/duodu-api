class Subway < ApplicationRecord
  translates :name

  validates :name, presence: true
  validates :source_id, presence: true, uniqueness: true

  has_and_belongs_to_many :stations

  def location
    return self.stations.first.try(:location)
  end  

  def self.find_by_region(region)
    stations = Station.joins("left join locations on locations.target_type = 'Station' and locations.target_id = stations.id").where("locations.#{region.class.to_s.split("::").last.downcase}_id = ?", region.id)
    Subway.where(id: stations.map{ |s| s.subway_ids }.flatten)
  end
end
