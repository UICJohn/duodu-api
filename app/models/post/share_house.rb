class Post::ShareHouse < Post::Base
  has_one :location, as: :target
  has_many_attached :attachments

  validates_numericality_of :rent
  validates_presence_of :location, :attachments
  validates :attachments, length: { maximum: 9 }
  validates :payment_type, :rent, :livings, :rent, :toilets, :rooms, :tenants, :property_type, presence: true

  enum property_type: [:house, :apartment, :studio, :unit]

  accepts_nested_attributes_for :location
end
