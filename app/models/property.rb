class Porperty < ApplicationRecord
  has_many :attachments, as: :attachable
  has_many :rooms, as: :parent
end