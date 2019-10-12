class Post::HouseMate < Post::Base
  validates :area_ids, presence: true
  validates_numericality_of :min_rent, :max_rent, allow_blank: true

  def areas
    Region::Suburb.where(id: area_ids).map(&:name)
  end
end
