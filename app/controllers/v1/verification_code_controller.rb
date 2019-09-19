class V1::VerificationCodeController < ApplicationController
  before_action :authenticate_user!, :if => :is_wechat?

  def create
    allow_to_send = if is_wechat?
      current_user.assign_attributes(send_code_params)
      current_user.valid?
    else
      User.find_by(send_code_params).blank?
    end

    if allow_to_send
      SendVerificationCodeWorker.perform_async(send_code_params.to_h)
      success!({message: '验证码已发送'})
    else
      error!({error: "手机号不正确或已被占用"})
    end
  end

  private
  def is_wechat?
    @platform == :wechat
  end

  def send_code_params
    if params[:email].present?
      params.permit(:email).reject!{ |attr| params[attr].blank? }
    else
      params.permit(:phone).reject!{ |attr| params[attr].blank? }
    end
  end
end