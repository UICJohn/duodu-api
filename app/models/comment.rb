class Comment < ApplicationRecord
  include Traceable

  validates :body, presence: true

  belongs_to :user
  belongs_to :target, polymorphic: true

  def sub_comments
    Comment.where(target: self)
  end
end
