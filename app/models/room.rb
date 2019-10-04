class Room < ApplicationRecord
  belongs_to :parent
  has_many :attachement, as: :attachable
end