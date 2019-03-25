class Users::RegistrationsController < Devise::RegistrationsController
  include ApplicationHelper
  def create
    build_resource(sign_up_params)

    resource.verification_code_required = true

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  def send_verify_code
    if params[:phone].present? and phone_validator(params[:phone])
      if User.find_by(phone: params[:phone]).present?
        flash[:error] = "手机号码已被占用, 请换个手机号码试试"
      else
        SendVerificationCodeWorker.perform_async(params[:phone])
      end
    else
      flash[:error] = '请输入正确的手机号码(目前仅支持中国大陆手机号)'
    end
  end

  def wait_for_activation

  end

  def after_inactive_sign_up_path_for(resource)
    users_wait_for_activation_path
  end
end