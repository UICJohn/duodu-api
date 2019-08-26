require 'net/http'
class Map

  def get_location_info(lon, lat)
    safe_env do
      url = "https://apis.map.qq.com/ws/geocoder/v1/"
      res = dispatch_request(url, method: 'GET', package: {location: "#{lat},#{lon}", key: ENV['map_key']})
      raise res['message'] if res['status'] != 0
      return res['result']['ad_info']
    end
  end

  private
  def dispatch_request(url, method: 'POST', package: nil)
    uri = URI.parse url

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == 'https')
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.set_debug_output($stdout) if Rails.env.development?

    path = (method.downcase == 'get' and package.present?) ?  "#{uri.path}?".concat(package.map{|k, v| "#{k}=#{CGI::escape(v)}" }.join('&')) : uri.path
    request = "Net::HTTP::#{method.capitalize}".constantize.new(path, initheader = {'Content-Type' =>'application/x-www-form-urlencoded'})
    request.set_form_data(package) if package.present?
    response = http.request(request)
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