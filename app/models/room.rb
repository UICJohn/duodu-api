class Room < ActiveRecord::Base
  belongs_to :parent
  has_many :attachement, as: :attachable
end