class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  attr_accessor :verification_code, :verification_code_required, :avatarUrl

  # devise :database_authenticatable, :async, :registerable, :trackable, :validatable, :jwt_authenticatable,
  #        jwt_revocation_strategy: JWTBlacklist, :authentication_keys => [:phone]

  devise :database_authenticatable, :async, :recoverable, :registerable, :trackable, :validatable, :confirmable, :jwt_authenticatable, jwt_revocation_strategy: JWTBlacklist,
          :authentication_keys => [:login]

  searchkick callbacks: :async

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: lambda{ |attachment| ActionController::Base.helpers.image_path("thumb/#{attachment.instance.gender || "male"}_avatar.png") }

  validate  :verify_phone, :if => :verification_code_required
  validate  :limited_tags
  validates :phone, presence: true, format: { with: /\A[0-9]{11}\z/, message: "invalid" }, uniqueness: true, unless: :omniauth_user?
  validates :verification_code, presence: true, :if => :verification_code_required
  validates :email, uniqueness: true, :allow_blank => true
  validates_format_of :email,:with => Devise::email_regexp, :allow_blank => true
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  has_one :preference
  
  accepts_nested_attributes_for :preference


  before_save :set_password_status, on: [:create, :update]
  before_save :fetch_avatar
  after_create :create_preference

  has_many :friend_requests, dependent: :destroy
  has_many :pending_friends, through: :friend_requests, source: :friend

  has_many :friendships
  has_many :friends, through: :friendships, :source => :user
  has_one  :wechat_credential

  enum password_status: [:weak, :good, :strong]

  def search_data
    {
      usernmae:   username,
      gender:     gender,
      occupation: occupation,
      first_name: first_name,
      last_name:  last_name,
      major:      major,
      country:    country,
      province:   province,
      city:       city,
      school:     school,
      share_location: preference.share_location,
      show_privacy_data: preference.show_privacy_data,
      receive_all_message: preference.receive_all_message,
    }
  end

  def limited_tags
    errors.add(:tags, "标签不能超过10个") if tags.size > 10
  end

  def email_required?
    false
  end

  def hidden_phone
    return nil if phone.blank?
    phone[0..2] + '*' * 4 + phone[-4..-1]
  end

  def hidden_email
    if unconfirmed_email.present?
      unconfirmed_email[0..2] + '*' * 4 + unconfirmed_email[(unconfirmed_email.index('@'))..-1]
    elsif email.present?
      email[0..2] + '*' * 4 + email[(email.index('@'))..-1]
    else
      nil
    end
  end

  def self.from_wechat(auth)
    where(provider: "wechat", uid: auth[:uid]).first_or_create do |user|
      user.password = Devise.friendly_token[0,20]
      user.session_key = auth[:session_key]
    end
  end

  private

  def confirmation_required?
    false
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(["phone = :value OR email = :value", { :value => login }]).first
    elsif conditions.has_key?(:phone) || conditions.has_key?(:email)
      where(conditions.to_hash).first
    end
  end

  def verify_phone
    begin
      raise unless VerificationCode.new(phone).verify? verification_code.strip
    rescue
      errors.add(:verification_code, "验证码不正确")
    end
  end

  def set_password_status
    return unless password.present?
    self.password_status = if password.match(/^(?=.*[a-zA-Z])(?=.*[0-9]).{10,}$/) 
      :strong
    elsif password.match(/^(?=.*[a-zA-Z])(?=.*[0-9]).{6,}$/) 
      :good
    else
      :weak
    end
  end

  def omniauth_user?
    self.uid.present? && self.provider.present?
  end

  def fetch_avatar

    FetchAvatarWorker.perform_async(self.id, avatarUrl) if self.avatarUrl.present?

  rescue Exception => e

    raise e unless Rails.env.production?

  end

  def create_preference
    self.preference = Preference.create
  end
end
