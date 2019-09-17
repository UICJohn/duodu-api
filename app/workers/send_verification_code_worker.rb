require 'aliyun/sms'

class SendVerificationCodeWorker

  include Sidekiq::Worker
  sidekiq_options :retry => 2

  def perform(target)
    VerificationCode.new(target).issue
  end

end