class Post::Housemate < Post::Base
  validates :range, :range, presence: true
  validates_numericality_of :min_rent, :max_rent, allow_blank: true
end
