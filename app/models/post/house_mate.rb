class Post::HouseMate < Post::Base

  has_one :location, as: :target, dependent: :destroy

  validates :min_rent, :max_rent, numericality: { allow_blank: true }
  validates :location, presence: true

  accepts_nested_attributes_for :location

end
