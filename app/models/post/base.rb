class Post::Base < ApplicationRecord
  include TimeTrackable

  self.table_name = 'posts'

  searchkick callbacks: :async

  belongs_to :user

  validates :title, :body, :available_from, presence: true

  delegate :gender,   to: :user, prefix: true
  delegate :username, to: :user

  scope :active, -> { where(active: true) }
end
