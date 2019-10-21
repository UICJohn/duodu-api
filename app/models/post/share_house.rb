class Post::ShareHouse < Post::Base
  has_one :location, as: :target
  has_many_attached :images

  validates_numericality_of :rent
  validates_presence_of :location
  validates :images, limit: { max: 8 }, content_type: /\Aimage\/.*\z/
  validates :images, attached: true, if: :active?
  validates :payment_type, :rent, :livings, :rent, :toilets, :rooms, :property_type, presence: true
  validates :tenants, numericality: { greater_than: 0 }
  validate  :can_active?

  enum property_type: [:house, :apartment, :studio]

  accepts_nested_attributes_for :location

  delegate :country, :city, :suburb, :name, :longitude, :latitude, to: :location

  scope :active, -> { where(active: true) }

  private

  def can_active?
    if active? and images.blank?
      errors.add(:images, 'you need to upload images')
    end
  end
end
