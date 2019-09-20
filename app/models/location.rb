class Location < ActiveRecord::Base
  belongs_to :target, polymorphic: true
  validates :longitude, :latitude, presence: true
end