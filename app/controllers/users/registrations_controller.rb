class Users::RegistrationsController < Devise::RegistrationsController

  respond_to :json

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
      error! resource.errors
    end
  end

  def send_verify_code
    if (phone = params[:phone].try(:strip)) && phone_validator(phone)
      if User.find_by(phone: phone).present?
        error!({error: "手机号码已被占用, 请换个手机号码试试"})
      else
        SendVerificationCodeWorker.perform_async(phone)
        success!({message: '验证码已发送'})
      end
    else
      error!({error: '请输入正确的手机号码(目前仅支持中国大陆手机号)'})
    end
  end

  def wait_for_activation

  end

  def after_inactive_sign_up_path_for(resource)
    users_wait_for_activation_path
  end

  private
  def phone_validator(phone_num)
    phone_num.match(/\A[0-9]{11}\z/) ? true : false
  end
end