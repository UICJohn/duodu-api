class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  attr_accessor :verification_code, :verification_code_required

  # devise :database_authenticatable, :async, :registerable, :trackable, :validatable, :jwt_authenticatable,
  #        jwt_revocation_strategy: JWTBlacklist, :authentication_keys => [:phone]

  devise :database_authenticatable, :async, :recoverable, :registerable, :trackable, :validatable, :confirmable,
          :authentication_keys => [:login]

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: lambda{ |attachment| ActionController::Base.helpers.image_path("thumb/#{attachment.instance.gender || "male"}_avatar.png") }

  validate  :verify_phone, :if => :verification_code_required
  validate  :limited_tags
  validates :phone, presence: true, format: { with: /\A[0-9]{11}\z/, message: "invalid" }, uniqueness: true
  validates :verification_code, presence: true, :if => :verification_code_required
  validates :email, uniqueness: true, :allow_blank => true
  validates_format_of :email,:with => Devise::email_regexp, :allow_blank => true
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
  
  has_one :preference
  
  accepts_nested_attributes_for :preference


  before_save :set_password_status, on: [:create, :update]
  after_create :create_preference

  enum password_status: [:weak, :good, :strong]


  def limited_tags
    errors.add(:tags, "标签不能超过10个") if tags.size > 10
  end

  def email_required?
    false
  end

  def hidden_phone
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

  def create_preference
    self.preference = Preference.create
  end
end
