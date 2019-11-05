require 'net/http'

namespace :region do
  task sync: :environment do
    def create_or_update_region(data, parent = nil, type = 'province')
      # Globalize.with_locale(:'zh-CN') do
      model = "Region::#{type.capitalize}".constantize
      attrs = {
        name: data['fullname'],
        pinyin: data['pinyin'].try(:join, ' '),
        tencent_id: data['id'],
        parent_id: parent.try(:id)
      }
      model.create_or_update(attrs)
      # end
    end

    country = Region::Country.find_by(code: 'CN')

    provinces, cities, suburbs = Map.fetch_regions

    return if provinces.blank?

    provinces.each do |json_province|
      # p json_province
      province = create_or_update_region(json_province, country)

      next unless (cities_position = json_province['cidx'])
      next unless (json_cities = cities[cities_position[0]...cities_position[1]])

      json_cities.each do |json_city|
        city = create_or_update_region(json_city, province, 'city')

        next unless (suburbs_position = json_city['cidx'])
        next unless (json_suburbs = suburbs[suburbs_position[0]...suburbs_position[1]])

        json_suburbs.each do |json_suburb|
          create_or_update_region(json_suburb, city, 'suburb')
        end
      end
    end

    Region::Province.with_translations.where(name: %w[北京市 天津市 上海市 重庆市]).find_each do |province|
      special_city = Region::City.create!(
        name: province.name,
        parent_id: province.id
      )
      province.cities.where.not(name: province.name).find_each do |city|
        city.assign_attributes(
          type: 'Region::Suburb',
          parent_id: special_city.id
        )

        city.save(validate: false)
      end
    end
  end

  task sync_subways: :environment do
    def sync_region(data)
      attrs = {
        name: data['cn_name'],
        baidu_id: data['code']
      }
      if (region = Region::Base.find_by(name: attrs[:name]))
        region.update!(attrs)
      end
    end

    begin
      Map.fetch_subway_cities.each { |city| sync_region(city) }
    rescue StandardError => e
      p e
    end

    Region::Base.where.not(baidu_id: nil).find_each do |region|
      next unless (subways = Map.fetch_subways_by(region))

      subways.each do |json_subway|
        next if Subway.find_by(source_id: json_subway['pair_line_uid'])

        subway = Subway.create_or_update({
                                           name: json_subway['line_name'].split('(').first,
                                            source_id: json_subway['line_uid']
                                         }, key: 'source_id')

        next unless subway.valid?

        json_subway['stops'].each do |json_station|
          station = Station.create_or_update({
                                               name: json_station['name'],
            source_id: json_station['uid']
                                             }, key: 'source_id')

          subway.stations << station unless subway.stations.include?(station)

          next if station.location.present?

          sleep(1)
          ActiveRecord::Base.transaction do
            if (point = Map.search_point(keyword: station.name.to_s, filter: 'category=地铁站', boundary: "region(#{region.name}, 0)"))
              Location.create!(
                country_id:   Region::Province.find_by(name: point['ad_info']['province']).try(:parent_id),
                province_id:  Region::Province.find_by(name: point['ad_info']['province']).try(:id),
                city_id:      Region::City.find_by(name: point['ad_info']['city']).try(:id),
                suburb_id:    Region::Suburb.find_by(name: point['ad_info']['district']).try(:id),
                address:      point['address'],
                latitude:     point['location']['lat'].to_f,
                longitude:    point['location']['lng'].to_f,
                target:       station
              )
              station.update(active: true)
            elsif (point = Map.search_point({ keywords: station.name, types: '150500', city: region.name }, service: 'gaode'))
              longitude, latitude = point['location'].split(',')
              Location.create(
                country_id:   Region::Province.find_by(name: point['pname']).try(:country_id),
                province_id:  Region::Province.find_by(name: point['pname']).try(:id),
                city_id:      Region::City.find_by(name: point['cityname']).try(:id),
                suburb_id:    Region::Suburb.find_by(name: point['adname']).try(:id),
                latitude:     latitude.to_f,
                longitude:    longitude.to_f,
                target:       station
              )
              station.update(active: true)
            end
          end
        end
      end
    rescue StandardError => e
      if Rails.env.production?
        p e
      else
        raise e
      end
    end
  end
end
