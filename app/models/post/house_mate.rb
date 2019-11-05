class Post::HouseMate < Post::Base
  has_many :locations, as: :target, dependent: :destroy

  validates :min_rent, :max_rent, numericality: { allow_blank: true }
  validates :locations, presence: true
  validates :locations, length: { maximum: 4 }

  before_create :actived

  accepts_nested_attributes_for :locations, allow_destroy: true

  private

  def actived
    self.active = true
  end
end
