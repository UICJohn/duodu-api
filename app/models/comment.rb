class Comment < ApplicationRecord
  has_many :attachement, as: :attachable
end