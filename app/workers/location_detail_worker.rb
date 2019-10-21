# frozen_string_literal: true

# Fetch location detail
class LocationDetailWorker
  include Sidekiq::Worker
  sidekiq_options retry: 2

  def perform(location_id, reverse: false)
    return if (location = Location.find_by(id: location_id))
    if reverse
      Map.reverse_geocode({ location: "#{location.latitude},#{location.longitude}" }) do |res|
        location.suburb_id = Region::Suburb.find_by(name: res["address_component"]['district']).try(:id)
        location.name = res['formatted_addresses']["recommend"] unless location.name
        location.address = res["address"] unless location.address
      end
    else
      Map.geocode({ address: location.address, region: location.try(:city).try(:name) }) do |res|
        if res['location'].present?
          location.longitude = res['location']['lng']
          location.latitude = res['location']['lat']
        end
      end
    end
    location.save
  end
end
