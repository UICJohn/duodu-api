class ApplicationController < ActionController::API
  include ActionController::Helpers
  include ActionController::Caching

  # before_action :set_storage_host, :if =>  proc { Rails.env.development? }
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_platform

  respond_to :json

  if Rails.env.production? || Rails.env.test?
    rescue_from Exception do |exception|
      error_message = "Oops, something went wrong. Here is the error message: #{exception}"
      e = Exception.new(error_message)
      e.set_backtrace(exception.backtrace)
      # ExceptionNotifier.notify_exception(e, env: request.env)
      if Rails.env.production?
        error!({msg: "Oops, something went wrong."})
      else
        raise exception
      end
    end
  end

  def set_platform
    agent = request.env['HTTP_USER_AGENT']
    return nil unless agent.present?   
    if _match = agent[/MicroMessenger\/([\d\.]+)/i, 1]
      @platform = :wechat
    else
      @platform = :web
    end
  end

  def error!(msg = {}, code = 200)
    self.response_body = msg.to_json
    self.status = code
  end

  def success!(msg = {}, code = 200)
    self.response_body = msg.to_json
    self.status = code
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :phone, :verification_code, :password, :role])
  end

  private
  def set_storage_host
    p request.base_url
    ActiveStorage::Current.host = request.base_url
  end
end
