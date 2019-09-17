class VerificationCode
  def initialize(target, expiries_in = 10.minutes.to_i)
    @key = target["email"] ? "email" : "phone"
    @target = target[@key]
    @expiries_in = expiries_in
  end

  def issue
    safe do
      self.send "send_code_by_#{@key}"
    end
  end

  def verified?(code)
    safe do
      if (record = fetch).present? and record["code"].to_s == code.to_s
        clean! && true 
      else
        false
      end
    end
  end

  private

  def record_name
    "#{@key}_#{@target}"
  end

  def send_code_by_sms
    return unless record_expired?
    code = generate_code
    if Rails.env.production?
      Aliyun::Sms.send(@target, 'SMS_129270223', "{'code': #{code}}")
    else
      puts "Verification Code: #{code}"
    end
  end

  def send_code_by_email
    return unless record_expired?
    code = generate_code
    puts "Verification Code: #{code}"
  end

  def record_expired?
    record = fetch
    return true if record.nil?
    return (Time.now - record["created_at"].to_time) > 1.minutes
  end

  def generate_code
    code = (0..6).map{Random.rand(9)}.join
    cache(code)
    code
  end

  def safe
    if @target.present?
      yield if block_given?
    else
      puts "#{@key} is not valid" if Rails.env.development?
    end
  end

  def cache(code)
    $redis.set(record_name, {code: code, created_at: Time.now}.to_json, ex: @expiries_in)
  end

  def fetch
    verify_record = $redis.get(record_name).present? ? JSON.parse($redis.get(record_name)) : nil
  end

  def clean!
    $redis.del(record_name)
  end
end
