class VerificationCode
  def initialize(target, expiries_in = 10.minutes.to_i)
    @key = target['email'] ? 'email' : 'phone'
    @target = target[@key]
    @expiries_in = expiries_in
  end

  def issue
    safe do
      send "send_code_by_#{@key}"
    end
  end

  def verified?(code)
    safe do
      if (record = fetch).present? && (record['code'].to_s == code.to_s)
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

  def send_code_by_phone
    return unless record_expired?

    code = generate_code
    cache(code)

    if Rails.env.production?
      Aliyun::Sms.send(@target, 'SMS_129270223', "{'code': #{code}}")
    else
      puts "Verification Code: #{code}" unless Rails.env.test?
    end
  end

  def send_code_by_email
    return unless record_expired?

    code = generate_code
    cache(code)
    # send email here
  end

  def record_expired?
    record = fetch
    return true if record.nil?

    (Time.now - record['created_at'].to_time) > 1.minutes
  end

  def generate_code
    "D-#{(0..6).map { Random.rand(9) }.join}"
  end

  def safe
    if @target.present?
      yield if block_given?
    elsif Rails.env.development?
      puts "#{@key} is not valid"
    else
      raise 'target not exists'
    end
  end

  def cache(code)
    $redis.set(record_name, { code: code, created_at: Time.now }.to_json, ex: @expiries_in)
  end

  def fetch
    $redis.get(record_name).present? ? JSON.parse($redis.get(record_name)) : nil
  end

  def clean!
    $redis.del(record_name)
  end
end
