module Regionable
  extend ActiveSupport::Concern

  REGION_ATTRIBUTES = %i[suburb city province country].freeze

  REGION_ATTRIBUTES.each do |region|
    define_method "#{region}_id=" do |region_id|
      idx = REGION_ATTRIBUTES.index(region)
      super(region_id)
      REGION_ATTRIBUTES[idx+1 .. -1].each do |parent_region|
        unless public_send("#{parent_region}_id_changed?")
          if (rgion_record = public_send("#{region}"))
            public_send("#{parent_region}_id=", rgion_record.public_send("#{parent_region}").try(:id))
          end
        end
      end if idx != REGION_ATTRIBUTES.length
    end
  end

end
