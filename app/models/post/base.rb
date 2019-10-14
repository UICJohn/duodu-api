class Post::Base < ApplicationRecord
  self.table_name = 'posts'

  include TimeTrackable
  searchkick callbacks: :async

  attr_accessor :post_type

  belongs_to :user

  validates :title, :body, :available_from, presence: true

  before_save :set_type, if: :new_record?

  enum post_type: ['take_house', 'share_house', 'house_mate']

  # def search_data
  #   %w[title body tenants range livings rooms toilets min_rent max_rent 
  #     has_air_conditioner has_elevator has_appliance has_cook_top has_furniture
  #     available_from].map { |key| [key, send(key)] }.to_h.merge({
  #       location: {
  #         lat: latitude,
  #         lon: longitude
  #       }
  #     })
  # end

  private

  def set_type
    raise "Post Type Invalid" if post_type.nil? and self.type == 'Post::Base'
    if post_type.present?
      self.type = "Post::#{post_type.camelcase}"
    end
  end
end
