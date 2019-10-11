class Tag < ApplicationRecord
  validates :name, presence: true
  belongs_to :category

  translates :name

  scope :occupation_tags, -> { where(category_id: Category.find_by(code_name: 'occupation').id) }
  scope :hobby_tags, -> { where(category_id: Category.find_by(code_name: 'hobby').id) }
end
