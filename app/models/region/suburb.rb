class Region::Suburb < Region::Base
  belongs_to :city, class_name: 'Region::City', foreign_key: 'parent_id'
  delegate :province, to: :city

  def country
    province.country
  end
end
