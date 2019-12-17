class Comment < ApplicationRecord
  belongs_to :target, polymorphic: true
  belongs_to :user
  has_many :sub_comments, as: :target, dependent: :destroy
end
