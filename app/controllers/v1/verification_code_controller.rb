class V1::VerificationCodeController < ApplicationController
  before_action :authenticate_user!, :if => :is_wechat?

  def create
    if is_wechat?
      current_user.assign_attributes(send_code_params)
      user = current_user
    else
      user = User.new(send_code_params)
    end

    if user.valid?
      SendVerificationCodeWorker.perform_async(send_code_params.to_h)
      success!({message: '验证码已发送'})
    else
      error!({msg: user.errors})
    end
  end

  private
  def is_wechat?
    @platform == :wechat
  end

  def send_code_params
    params.permit(:email, :phone).reject!{ |attr| params[attr].blank? }
  end
end