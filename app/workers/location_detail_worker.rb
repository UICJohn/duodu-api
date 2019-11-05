# frozen_string_literal: true

# Fetch location detail
class LocationDetailWorker
  include Sidekiq::Worker
  sidekiq_options retry: 2

  def perform(location_id, reverse = false)
    return unless (location = Location.find_by(id: location_id))

    if reverse
      res = Map.reverse_geocode(location: "#{location.latitude},#{location.longitude}")
      location.suburb_id = Region::Suburb.find_by(name: res['address_component']['district']).try(:id)
      location.name = res['formatted_addresses']['recommend'] if location.name.blank?
      location.address = res['address'] if location.address.blank?
    else
      res = Map.geocode(address: location.address, region: location.try(:city).try(:name))
      if res['location'].present?
        location.longitude = res['location']['lng']
        location.latitude = res['location']['lat']
      end
    end
    location.save
  end
end
