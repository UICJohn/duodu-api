require 'aliyun/sms'

class SendVerificationCodeWorker

  include Sidekiq::Worker
  sidekiq_options :retry => 2

  def perform(phone_num, prefix = nil)
    VerificationCode.new(phone_num, prefix).issue
  end

end