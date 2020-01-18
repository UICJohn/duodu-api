class Post::Base < ApplicationRecord
  include PostImageable
  include Traceable

  self.table_name = 'posts'

  searchkick callbacks: :async

  belongs_to :user
  has_many :post_collections, foreign_key: 'post_id'
  has_many :comments, as: :target

  validates :title, :body, :available_from, presence: true

  delegate :gender,   to: :user, prefix: true
  delegate :username, to: :user

  default_scope { order('id DESC') }
  scope :active, -> { where(active: true) }

  enum tenants_gender: { male: 0, female: 1, unisex: 2 }

  def can_active?
    return false if %i[city_id suburb_id].any? { |col| location.send(col).blank? }

    return false if !is_a?(Post::HouseMate) && !images.attached?

    true
  end

  def comments_count
    comments.count + (comments.map{ |comment| comment.sub_comments.count }.inject(:+) || 0)
  end

  def contact
    use_user_contact ? user.phone : phone
  end
end
