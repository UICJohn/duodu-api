class Location < ApplicationRecord
  include Regionable

  belongs_to :target, polymorphic: true
  belongs_to :country, class_name: 'Region::Country', optional: true
  belongs_to :province, class_name: 'Region::Province', optional: true
  belongs_to :city, class_name: 'Region::City', optional: true
  belongs_to :suburb, class_name: 'Region::Suburb', optional: true

  validate :key_fields_present?

  after_create :fetch_location_detail

  private

  def key_fields_present?
    return true if address.present? or %i[longitude latitude].all? { |col| send(col).present? }
    errors.add(:base, "key fields missing")
  end

  def fetch_location_detail
    if %i[address name country city suburb province].any? { |col| public_send("#{col}").nil? } \
      && %i[latitude longitude].all? { |col| public_send("#{col}").present? }
      LocationDetailWorker.perform_in(5.seconds, id, true)
    elsif %i[latitude longitude].any? { |col| public_send("#{col}").blank? } && address.present?
      LocationDetailWorker.perform_in(5.seconds, id)
    end
  end
end
