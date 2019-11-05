require 'net/http'

module Wechat
  module Helper
    def get(url, data: nil)
      dispatch_request(url, package: data, method: 'GET')
    end

    def post(url, form_data: nil)
      dispatch_request(url, package: form_data, method: 'POST')
    end

    def delete(url, form_data: nil)
      dispatch_request(url, package: form_data, method: 'DELETE')
    end

    private

    def safe_env
      response = yield

      response['errcode'].present? && response['errcode'] != 0 ? (raise response['errmsg']) : (return response)
    rescue StandardError => e
      raise e unless Rails.env.production?
    end

    def dispatch_request(url, method: 'POST', package: nil)
      uri = URI.parse url

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == 'https')
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.set_debug_output($stdout) if Rails.env.development?

      path = (method.casecmp('get').zero? && package.present?) ? "#{uri.path}?".concat(package.map { |k, v| "#{k}=#{CGI.escape(v)}" }.join('&')) : uri.path

      request = "Net::HTTP::#{method.capitalize}".constantize.new(path, 'Content-Type' => 'application/x-www-form-urlencoded')
      request.set_form_data(package) if package.present?

      response = http.request(request)
      if response.body.present?
        JSON.parse(response.body)
      end
    end
  end

  class API
    include Helper

    def initialize
      raise 'env not set' if ENV['wechat_app_id'].nil? && ENV['wechat_app_secrets'].nil?
    end

    def auth(code)
      safe_env do
        url = 'https://api.weixin.qq.com/sns/jscode2session'
        get(url, data: {
              appid: ENV['wechat_app_id'],
          secret: ENV['wechat_app_secrets'],
          js_code: code,
          grant_type: 'authorization_code'
            })
      end
    end
  end
end
