class LocationDetailWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 2

  def perform(location_id)
    if location = Location.find_by(id: location_id)
      res = Map.new.get_location_info(location.longitude.to_f, location.latitude.to_f)
      location.update_attributes!(
        province: res['province'],
        country:  ISO3166::Country.find_country_by_name(res['nation']).alpha2,
        city:     res['city'],
        suburb:   res['district']
      )
    end
  end
end