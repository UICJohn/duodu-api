require 'net/http'
class Map

  def get_location_by(lat:, lon:)
    safe_env do
      url = "https://apis.map.qq.com/ws/geocoder/v1/"
      res = dispatch_request(url, method: 'GET', package: {location: "#{lat},#{lon}", key: ENV['map_key']})
      raise res['message'] if res['status'] != 0
      return res['result']['ad_info']
    end
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
    [response["result"][0], response["result"][1], response["result"][2]]
  end

  def search_point(options)
    url = "https://restapi.amap.com/v3/place/text"
    response = dispatch_request(
      url,
      method: 'GET',
      package: options.merge({
        key: ENV['gmap_key']
      })
    )
    return nil unless ActiveRecord::Type::Boolean.new.cast(response['status'])
    return response["pois"]
  end

  def fetch_subway_cities
    url = 'http://map.baidu.com/'
    response = dispatch_request(url, method: 'GET', package: {qt: 'subwayscity', 't': '123457788'})
    response["subways_city"]["cities"]
  end

  def fetch_subways_by(region)
    url = "http://map.baidu.com/"
    response = dispatch_request(
      url,
      method: 'GET',
      package: {
        qt: 'bsi',
        c: region.baidu_id,
        t: '1469072745455'
      }
    )
    response["content"]
  end

  private
  def dispatch_request(url, method:'POST', package: nil)
    uri = URI(url)

    response = if(method == 'GET')
      uri.query = URI.encode_www_form(package) if package.present?
      Net::HTTP.get_response(uri)
    else
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == 'https')
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.set_debug_output($stdout) if Rails.env.development?

      request = "Net::HTTP::#{method.capitalize}".constantize.new(path, initheader = {'Content-Type' =>'application/x-www-form-urlencoded'})
      request.set_form_data(package) if package.present?
      http.request(request)
    end
    if response.body.present?
      JSON.parse(response.body)
    end
  end

  def safe_env
    begin
      yield
    rescue Exception => e
      if !Rails.env.produciton?
        raise e
      end
    end
  end
end