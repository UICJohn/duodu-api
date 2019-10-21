class Location < ApplicationRecord
  include Regionable

  belongs_to :target, polymorphic: true
  belongs_to :country, class_name: 'Region::Country', optional: true
  belongs_to :province, class_name: 'Region::Province', optional: true
  belongs_to :city, class_name: 'Region::City', optional: true
  belongs_to :suburb, class_name: 'Region::Suburb', optional: true

  validates :longitude, :latitude, presence: true  

  after_create :fetch_location_detail

  private

  def fetch_location_detail
    if %i[address name country city suburb province].any? { |col| public_send("#{col}").nil? } \
      && %i[latitude longitude].all? { |col| public_send("#{col}").present? }
      LocationDetailWorker.perform_async(id, reverse: true)
    elsif %i[latitude longitude].any? { |col| public_send("#{col}").blank? } && address.present?
      LocationDetailWorker.perform_async(id)
    end
  end
end
