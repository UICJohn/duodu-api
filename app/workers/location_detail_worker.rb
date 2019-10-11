# frozen_string_literal: true

# Fetch location detail
class LocationDetailWorker
  include Sidekiq::Worker
  sidekiq_options retry: 2

  def perform(location_id)
    if (location = Location.find_by(id: location_id))
      region = Region::Base.where(id: %w[country_id province_id city_id suburb_id].map { |key| location.send(key) })

      res = Map.search_point(keyword: station.name, boundary: "region(#{region.name}, 0)") \
            || Map.search_point({ keywords: station.name, city: region.name }, service: 'gaode')

      location.update_attributes(
        country_id:  Region::Country.find_by(name: res['nation']).id,
        province_id: Region::Province.find_by(name: res['province']).id,
        city_id:     Region::City.find_by(name: res['city']).id,
        suburb_id:   Region::Suburb.find_by(name: res['district']).id,
        name:        res['name']
      )
    end
  end
end
