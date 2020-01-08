class User < ApplicationRecord
  strip_attributes
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  attr_accessor :code, :avatar_url, :update_key_attr

  devise :database_authenticatable, :async, :recoverable, :registerable, :trackable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: JWTBlacklist,
          authentication_keys: [:login]

  has_one_attached :avatar

  validate  :verify_code, if: :update_key_attr
  validate  :limited_tags
  validates :phone, presence: true, unless: :omniauth_user?
  validates :code, presence: true, if: :update_key_attr
  validates :email, uniqueness: true, allow_blank: true
  validates :phone, format: { with: /\A[0-9]{11}\z/, message: '手机号不正确' }, uniqueness: true, allow_blank: true
  validates :avatar, content_type: %r{\Aimage/.*\z}
  validates :email, format: { with: Devise.email_regexp, allow_blank: true }


  has_one  :location, as: :target
  has_one  :preference
  has_many :friend_requests, dependent: :destroy
  has_many :pending_friends, through: :friend_requests, source: :friend
  has_many :friendships
  has_many :friends, through: :friendships, source: :user
  has_many :posts, class_name: 'Post::Base'
  has_many :post_collections
  has_many :like_posts, through: :post_collections, source: :post
  has_many :comments
  has_many :notifications, foreign_key: 'receiver_id'

  before_save :set_password_status
  before_save :fetch_avatar
  after_create :setup_user

  accepts_nested_attributes_for :preference, :location

  enum password_status: { weak: 0, good: 1, strong: 2 }
  enum gender: { 'female' => 0, 'male' => 1, 'unisex' => 2 }

  def limited_tags
    errors.add(:tags, '标签不能超过10个') if tags.size > 10
  end

  def email_required?
    false
  end

  def hidden_phone
    return nil if phone.blank?

    phone[0..2] + '*' * 4 + phone[-4..-1]
  end

  def hidden_email
    if email.present?
      email[0..2] + '*' * 4 + email[(email.index('@'))..-1]
    end
  end

  def self.from_wechat(auth)
    where(provider: 'wechat', uid: auth[:uid]).first_or_create! do |user|
      user.password = Devise.friendly_token[0, 20] if user.password.nil?
      user.session_key = auth[:session_key]
    end
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_hash).where(['phone = :value OR email = :value', { value: login }]).first
    elsif conditions.key?(:phone) || conditions.key?(:email)
      where(conditions.to_hash).first
    end
  end

  def age
    Date.today.year - (dob&.year || 2000)
  end

  private

  def confirmation_required?
    false
  end

  def verify_code
    raise unless VerificationCode.new(
      update_key_attr.to_s => send(update_key_attr)
    ).verified?(code.strip)
  rescue StandardError
    errors.add(:code, '验证码不正确')
  end

  def set_password_status
    return if password.blank?

    self.password_status = if /^(?=.*[a-zA-Z])(?=.*[0-9]).{10,}$/.match?(password)
                             :strong
                           elsif /^(?=.*[a-zA-Z])(?=.*[0-9]).{6,}$/.match?(password)
                             :good
                           else
                             :weak
                           end
  end

  def omniauth_user?
    uid.present? && provider.present?
  end

  def fetch_avatar
    FetchAvatarWorker.perform_async(id, avatar_url) if avatar_url.present?
  rescue StandardError => e
    raise e unless Rails.env.production?
  end

  def setup_user
    self.preference = Preference.create
  end
end
