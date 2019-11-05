class Post::ShareHouse < Post::Base
  include PostImageable

  has_one :location, as: :target, dependent: :destroy
  has_many_attached :images

  validates :rent, numericality: true
  validates :location, presence: true
  validates :images, limit: { max: 8 }, content_type: %r{\Aimage/.*\z}
  validates :images, attached: true, if: :active?
  validates :payment_type, :rent, :livings, :rent, :toilets, :rooms, :property_type, presence: true
  validates :tenants, numericality: { greater_than: 0 }

  accepts_nested_attributes_for :location, allow_destroy: true

  delegate :country, :city, :suburb, :name, :longitude, :latitude, to: :location
end
