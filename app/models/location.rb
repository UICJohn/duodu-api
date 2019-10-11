class Location < ApplicationRecord
  belongs_to :target, polymorphic: true
  belongs_to :country, class_name: 'Region::Country', optional: true
  belongs_to :province, class_name: 'Region::Province', optional: true
  belongs_to :city, class_name: 'Region::City', optional: true
  belongs_to :suburb, class_name: 'Region::Suburb', optional: true

  validates :longitude, :latitude, presence: true

  after_save :fetch_location_detail

  private

  def fetch_location_detail
    LocationDetailWorker.perform_in(5.seconds, id)
  end
end
