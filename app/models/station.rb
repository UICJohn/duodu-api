class Station < ApplicationRecord
  has_and_belongs_to_many :subways
  has_one :location, as: :target, dependent: :destroy

  validates :name, presence: true
  validates :source_id, presence: true, uniqueness: true

  scope :active, -> { where(active: true) }
end
