class Post::ShareHouse < Post::Base
  has_many_attached :attachments

  validates :payment_type, :rent, presence: true
  validates_numericality_of :rent
  validates :attachments, length: { maximum: 9 }
end
