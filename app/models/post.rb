class Post < ApplicationRecord
  include TimeTrackable

  # searchkick callbacks: :async

  belongs_to :user
  has_many_attached :attachments
  has_one :location, as: :target

  validates :attachments, :length => { :maximum => 9 }
  validates :title, :body, :post_type, :available_from, presence: true
  validates :range, :range, presence: true, if: :housemate_post?
  validates :payment_type, :rent_type, :rent, presence: true, if: :house_post?
  validates_numericality_of :min_rent, :rent, :max_rent, allow_blank: true
  validates_presence_of :location

  enum post_type: [:take_house, :share_house, :housemate, :activity]

  accepts_nested_attributes_for :location

  delegate :country, :city, :suburb, :name, :longitude, :latitude, to: :location

  # def search_data
  #   %w(title body post_type address range min_rent max_rent payment_type
  #     rent_type available_from city province country suburb has_sofa 
  #     has_bed has_air_conditioner has_elevator has_washing_machine 
  #     has_cook_top has_refregitor rooms livings toilets created_at
  #   ).map do |key|
  #     if val = self.send(key)
  #       [ key, val ]
  #     end
  #   end.compact.to_h.merge(location: {lat: self.location.latitude, lon: self.location.longitude})
  # end

  private
  def house_post?
    post_type == :house
  end

  def housemate_post?
    post_type == :housemate
  end

  def activity_post?
    not housemate_post? and not not house_post?
  end  
end