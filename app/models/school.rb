class School < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :department, :code, presence: true

  searchkick callbacks: :async

  def search_data
    {
      name:   name,
      department: department,
      py: py
    }
  end
end
