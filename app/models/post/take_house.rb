class Post::TakeHouse < Post::Base
  has_many_attached :attachments

  validates :payment_type, :rent, presence: true
  validates :attachments, length: { maximum: 9 }
  validates_numericality_of :rent
end
