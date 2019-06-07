class Category < ApplicationRecord
  validates :name, presence: true
  has_many :tag

  translates :name
end