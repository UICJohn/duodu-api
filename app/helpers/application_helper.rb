module ApplicationHelper
  private

  def generate_filters(options = {})
    return unless options.present?

    filters = {}
    location_filters = {}

    if options[:min_rent].present?
      filters['rent >= ?'] = options[:min_rent]
    end

    if options[:max_rent].present?
      filters['rent <= ?'] = options[:max_rent]
    end

    if options[:has_furniture].present?
      filters['has_furniture = ? '] = options[:has_furniture]
    end

    if options[:has_elevator].present?
      filters['has_elevator = ?'] = options[:has_elevator]
    end

    if options[:has_appliance].present?
      filters['has_appliance = ?'] = options[:has_appliance]
    end

    if options[:city].present? && (city = Region::City.find_by(name: options[:city]))
      location_filters[:city_id] = city.id
    end

    if options[:suburb].present? && (suburb = Region::Suburb.find_by(name: options[:suburb]))
      location_filters[:suburb_id] = suburb.id
    end

    # if options[:subways]
    if options[:livings].present?
      filters[:livings] = options[:livings]
    end

    if options[:rooms].present?
      filters[:rooms] = options[:rooms]
    end

    if options[:toilets].present?
      filters[:toilets] = options[:toilets]
    end

    if options[:available_from].present?
      filters['available_from <= ?'] = options[:available_from]
    end

    # if options[:address].present?
    #   location_filters[:address] = options[:address]
    # end
  end
end
