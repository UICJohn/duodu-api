class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  # before_action :validate_receiver

  def create
    build_resource(sign_up_params)

    resource.verification_code_required = true
    resource.save
    yield resource if block_given?
    if resource.persisted?
      sign_up(resource_name, resource)
      render json: resource
    else
      clean_up_passwords resource
      set_minimum_password_length
      error!(error: resource.errors)
    end
  end

  def send_verify_code
    user = User.new(verification_params)
    if user.valid?
      SendVerificationCodeWorker.perform_async(phone)
      success!(message: '验证码已发送')
    else
      error!
    end
  end

  def after_inactive_sign_up_path_for(_resource)
    users_wait_for_activation_path
  end

  private

  def verification_params
    params.permit(:phone, :email, :verification_code)
  end
end
