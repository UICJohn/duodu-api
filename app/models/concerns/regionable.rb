module Regionable
  extend ActiveSupport::Concern

  REGION_ATTRIBUTES = %i[suburb city province country].freeze

  REGION_ATTRIBUTES.each do |region|
    define_method "#{region}_id=" do |region_id|
      super(region_id)
      return if region_id.nil?

      idx = REGION_ATTRIBUTES.index(region)
      return if idx == (REGION_ATTRIBUTES.length - 1)
      return unless (region_record = public_send("#{region}"))

      REGION_ATTRIBUTES[idx+1 .. -1].each do |parent_region|
        next if public_send("#{parent_region}_id_changed?")
        public_send("#{parent_region}_id=", \
          region_record.public_send("#{parent_region}").try(:id))
      end
    end
  end
end
