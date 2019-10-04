class LocationDetailWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 2

  def perform(location_id)
    if location = Location.find_by(id: location_id)
      return unless ["country_id", "province_id", "city_id", "suburb_id", "name"].map{ |attr| location.send(attr) }.include?(nil)
      res = Map.new.get_location_by(lat: location.latitude.to_f, lon: location.longitude.to_f)
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