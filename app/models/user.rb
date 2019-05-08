class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  attr_accessor :verification_code, :verification_code_required

  devise :database_authenticatable, :async, :registerable, :trackable, :validatable, :jwt_authenticatable,
         jwt_revocation_strategy: JWTBlacklist, :authentication_keys => [:phone]

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: lambda{ |attachment| ActionController::Base.helpers.image_path("thumb/#{attachment.instance.gender || "male"}_avatar.png") }

  # validates :phone, presence: true, format: { with: /\A[0-9]{11}\z/, message: "invalid" }, uniqueness: true
  validates :phone, presence: true
  validates :verification_code, presence: true, :if => :verification_code_required
  validate  :verify_phone, :if => :verification_code_required
  validates_format_of :email,:with => Devise::email_regexp, :allow_blank => true
  validates :email, uniqueness: true, :allow_blank => true
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  def email_required?
    false
  end

  private

  def verify_phone
    begin
      raise unless VerificationCode.new(phone).verify? verification_code.strip
    rescue
      errors.add(:verification_code, "invalid")
    end
  end

end