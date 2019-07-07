class Post < ActiveRecord::Base
  has_many :rooms, as: :parent
  has_many :attachement, as: :attachable
  validates :title, :body, :province, :city, :suburb, presence: true, unless: :draft
end