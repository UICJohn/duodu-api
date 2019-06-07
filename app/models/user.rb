class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  attr_accessor :verification_code, :verification_code_required

  # devise :database_authenticatable, :async, :registerable, :trackable, :validatable, :jwt_authenticatable,
  #        jwt_revocation_strategy: JWTBlacklist, :authentication_keys => [:phone]

  devise :database_authenticatable, :async, :recoverable, :registerable, :trackable, :validatable, 
          :authentication_keys => [:login]

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: lambda{ |attachment| ActionController::Base.helpers.image_path("thumb/#{attachment.instance.gender || "male"}_avatar.png") }

  validates :phone, presence: true, format: { with: /\A[0-9]{11}\z/, message: "invalid" }, uniqueness: true
  validates :verification_code, presence: true, :if => :verification_code_required
  validate  :verify_phone, :if => :verification_code_required
  validates_format_of :email,:with => Devise::email_regexp, :allow_blank => true
  validates :email, uniqueness: true, :allow_blank => true
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  def email_required?
    false
  end

  private

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
      errors.add(:verification_code, "invalid")
    end
  end

end
