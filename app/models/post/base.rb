class Post::Base < ApplicationRecord
  include TimeTrackable

  self.table_name = 'posts'

  searchkick callbacks: :async

  belongs_to :user
  has_many :post_collections, foreign_key: 'post_id'

  validates :title, :body, :available_from, presence: true

  delegate :gender,   to: :user, prefix: true
  delegate :username, to: :user

  scope :active, -> { where(active: true) }

  def can_active?
    if is_a?(Post::HouseMate) && locations.any?{ |location| %i[city_id suburb_id].all? { |col| location.send(col).present? } }
      true
    elsif %i[city_id suburb_id].all? { |col| location.send(col).present? && images.attached? }
      true
    else
      false
    end
  end
end
