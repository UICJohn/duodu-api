require 'net/http'
class Map
  class << self
    def location_info(options, reverse: false)
      send("#{reverse ? 'reverse_' : ''}geocode", options)
    end

    def fetch_regions
      url = 'https://apis.map.qq.com/ws/district/v1/list'
      response = dispatch_request(
        url,
        method: 'GET',
        package: {
          key: ENV['tmap_key']
        }
      )
      [response['result'][0], response['result'][1], response['result'][2]]
    end

    def search_point(options, service: 'tencent')
      if service == 'tencent'
        tencent_search(options)
      else
        gaode_search(options)
      end
    end

    def fetch_subway_cities
      url = 'http://map.baidu.com/'
      response = dispatch_request(url, method: 'GET', package: { qt: 'subwayscity', 't': '123457788' })
      response['subways_city']['cities']
    end

    def fetch_subways_by(region)
      url = 'http://map.baidu.com/'
      response = dispatch_request(
        url,
        method: 'GET',
        package: {
          qt: 'bsi',
          c: region.baidu_id,
          t: '1469072745455'
        }
      )
      response['content']
    end

    private

    def gaode_search(options)
      url = 'https://restapi.amap.com/v3/place/text'
      params = request_params(%w[keywords types city citylimit children offset page extensions sig output key], options)
      params.merge!(key: ENV['gmap_key']) unless params[:key].present?
      response = dispatch_request(url, method: 'GET', package: params)
      return nil unless ActiveRecord::Type::Boolean.new.cast(response['status'])

      response['pois'].first
    end

    def tencent_search(options)
      url = 'https://apis.map.qq.com/ws/place/v1/search'
      params = request_params(%w[keyword boundary filter orderby page_size page_index key output], options) do |key, val|
        if key == :boundary
          boundary_params = val.gsub(/\s+/, '').split(/\(|\,|\)/).flatten
          [key, "#{boundary_params[0]}(#{boundary_params[1..-1].map { |v| url_encode(v) }.join(',')})"]
        elsif key == :filter
          boundary_params = val.gsub(/\s+/, '').split(/\=|\,/).flatten
          [key, "#{boundary_params[0]}=#{boundary_params[1..-1].map { |v| url_encode(v) }.join(',')}"]
        else
          [key, url_encode(val)]
        end
      end

      params.merge!(key: ENV['tmap_key']) unless params[:key].present?
      response = dispatch_simple_request(url, params: params)
      raise response['message'] if response['status'] != 0

      response['data'].first
    end

    def geocode(options)
      return nil if options[:address].nil?

      safe_env do
        url = 'https://apis.map.qq.com/ws/geocoder/v1/'
        params = request_params(%w[address region key output], options)
        params.merge!(key: ENV['tmap_key']) unless params[:key].present?
        res = dispatch_request(url, method: 'GET', package: params)
        raise res['message'] unless res['status'].zero?

        return res['result']['ad_info']
      end
    end

    def reverse_geocode(options)
      return nil if options[:locaiton].nil?

      safe_env do
        url = 'https://apis.map.qq.com/ws/geocoder/v1/'
        params = request_params(%w[location get_poi poi_options key output], options)
        params.merge!(key: ENV['tmap_key']) unless params[:key].present?
        res = dispatch_request(url, method: 'GET', package: params)
        raise res['message'] if res['status'] != 0

        return res['result']['ad_info']
      end
    end

    def request_params(list, options, &block)
      list.map do |key|
        next unless options[key.to_sym].present?

        if block
          block.call(key.to_sym, options[key.to_sym])
        else
          [key.to_sym, options[key.to_sym]]
        end
      end.compact.to_h
    end

    def dispatch_request(url, method: 'POST', package: nil)
      uri = URI(url)
      response = if method == 'GET'
                   uri.query = URI.encode_www_form(package) if package.present?
                   Net::HTTP.get_response(uri)
                 else
                   http = Net::HTTP.new(uri.host, uri.port)
                   http.use_ssl = (uri.scheme == 'https')
                   http.verify_mode = OpenSSL::SSL::VERIFY_NONE
                   http.set_debug_output($stdout) if Rails.env.development?
                   request = "Net::HTTP::#{method.capitalize}".constantize.new(uri.path, 'Content-Type' => 'application/x-www-form-urlencoded')
                   request.set_form_data(package) if package.present?
                   http.request(request)
                 end
      if response.body.present?
        JSON.parse(response.body)
      else
        response
      end
    end

    def dispatch_simple_request(url, method: 'GET', params: {})
      params_str = params.map { |k, v| "#{k}=#{v}" }.join('&')
      uri = URI(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == 'https')
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      path = "#{url}?#{params_str}"
      request = "Net::HTTP::#{method.capitalize}".constantize.new(path, 'Content-Type' => 'application/x-www-form-urlencoded')
      response = http.request(request)
      if response.body.present?
        JSON.parse(response.body)
      else
        response
      end
    end

    def safe_env
      yield
    rescue StandardError => e
      unless Rails.env.produciton?
        raise e
      end
    end
  end
end
