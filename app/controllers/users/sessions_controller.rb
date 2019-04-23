class Users::SessionsController < Devise::SessionsController
  respond_to :json


  protected
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:users, keys: [:phone, :password])
  end

  private

  def respond_with(resource, _opts = {})
    render json: resource
  end

  def respond_to_on_destroy
    head :no_content
  end

end
