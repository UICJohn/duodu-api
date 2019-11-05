class Category < ApplicationRecord
  validates :name, presence: true
  has_many :tag, dependent: :destroy

  translates :name
end
