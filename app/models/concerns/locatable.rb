module Locatable
  extend ActiveSupport::Concern

  included do
    after_save :fetch_location_detail
  end

  private

  def fetch_location_detail
    LocationDetailWorker.perform_async(location.id) if location.present?
  end

end
