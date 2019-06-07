class Users::PasswordsController < Devise::PasswordsController
  respond_to :json

  def create
    result = params[:user][:phone].present? ? reset_by_phone : reset_by_email

    result['error'].present? ? error!(result) : success!(result)
  end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)    
      resource.after_database_authentication
      sign_in(resource_name, resource)
      success!
    else
      error!({error: resource.errors})
    end
  end

  def send_verify_code
    if params[:phone].present? && (user = User.find_by(phone: params[:phone]))
      SendVerificationCodeWorker.perform_async(params[:phone], "reset_password")
      success!({ "message" => "验证码已发送"})
    else
      error!({ "error" => "用户不存在" })
    end
  end


  private
  def reset_by_phone
    return {"error" => '手机号码不存在'} unless self.resource = User.find_by(phone: params[:user][:phone])

    if VerificationCode.new(params[:user][:phone], 'reset_password').verify?(params[:user][:verification_code])
      return {reset_token: resource.send(:set_reset_password_token)}
    end

    return {"error" => '验证码不正确'}
  end

  def reset_by_email
    self.resource = resource_class.send_reset_password_instructions(resource_params)

    yield resource if block_given?

    return successfully_sent?(resource) ? {"error" => '邮箱不正确'} : {"message" => '验证邮件已发送'}
  end

end