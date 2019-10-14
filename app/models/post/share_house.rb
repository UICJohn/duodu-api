class Post::ShareHouse < Post::Base
  has_one :location, as: :target
  has_many_attached :attachments

  validates_numericality_of :rent
  validates_presence_of :location
  validates :attachments, limit: { max: 8 }
  validates :payment_type, :rent, :livings, :rent, :toilets, :rooms, :tenants, :property_type, presence: true
  validate  :can_active?

  enum property_type: [:house, :apartment, :studio]

  accepts_nested_attributes_for :location

  delegate :country, :city, :suburb, :name, :longitude, :latitude, to: :location

  scope :active, -> { where(active: true) }

  private
  def can_active?
    if active? and attachments.blank?
      errors.add(:attachments, 'you need to upload attachments')
    end
  end
end
