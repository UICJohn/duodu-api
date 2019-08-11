class Occupation < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  searchkick callbacks: :async

  def search_data
    {
      name:   name,
      py: py
    }
  end
end
