class Region::City < Region::Base
  belongs_to :province, class_name: "Region::Province", foreign_key: 'parent_id'  
  has_many :suburbs, class_name: "Region::Suburb", foreign_key: 'parent_id'
end