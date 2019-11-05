class Region::Suburb < Region::Base
  belongs_to :city, class_name: 'Region::City', foreign_key: 'parent_id'
  delegate :province, to: :city

  delegate :country, to: :province
end
