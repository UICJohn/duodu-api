class Post::Base < ApplicationRecord
  include TimeTrackable

  attr_accessor :post_type

  self.table_name = 'posts'

  belongs_to :user
  has_one :location, as: :target

  validates :title, :body, :available_from, presence: true
  validates_presence_of :location

  accepts_nested_attributes_for :location

  delegate :country, :city, :suburb, :name, :longitude, :latitude, to: :location

  before_save :set_type

  def self.search(filters, _location_filters)
    relation = self
    filters.each do |k, v|
      if k.is_a?(String)
        relation = relation.where(k, v)
      elsif k.is_a?(Symbol)
        relation = relation.where(k => v)
      end
    end
    relation
  end

  private

  def set_type
    if post_type.present?
      self.type = case post_type
                  when 0
                    'Post::TakeHouse'
                  when 1
                    'Post::ShareHouse'
                  when 2
                    'Post::Housemate'
                  else
                    raise 'Post Type Error'
                  end
    end
  end
end
