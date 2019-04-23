class VerificationCode
  def initialize(phone, prefix = nil, expiries_in = 10.minutes.to_i)
    @phone = phone
    @@prefix = prefix
    @expiries_in = expiries_in
  end

  def issue
    safe do
      send_code_via_sms
    end
  end

  def verify?(code)
    safe do
      if (record = fetch).present? and record["code"].to_s == code.to_s
        clean!
        true
      else
        false
      end
    end
  end

  private

  def send_code_via_sms
    record = fetch
    if record.nil? or (Time.now - record["created_at"].to_time) > 1.minutes
      code = (0..6).map{Random.rand(9)}.join
      cache(code)
      if Rails.env.production? or Rails.env.staging?
        Aliyun::Sms.send(@phone, 'SMS_129270223', "{'code': #{code}}")
      else
        puts "Verification Code: #{code}"
      end
    end
  end

  def safe
    if @phone.present?
      yield if block_given?
    else
      puts "No phone provided or phone number is not valid" if Rails.env.development?
    end
  end

  def cache(code)
    $redis.set(key, {code: code, created_at: Time.now}.to_json, ex: @expiries_in)
  end

  def key
    Digest::SHA256.digest [@prefix, @phone].compact.join("_")
  end

  def fetch
    verify_record = $redis.get(key).present? ? JSON.parse($redis.get(key)) : nil
  end

  def clean!
    puts 'Clean Done!'
    $redis.del(key)
  end
end
