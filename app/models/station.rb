class Station < ApplicationRecord
  translates :name

  has_and_belongs_to_many :subways
  has_one  :location, as: :target, dependent: :destroy

  validates :source_id, presence: true, uniqueness: true

end