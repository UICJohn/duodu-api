class Region::Province < Region::Base
  belongs_to :country, class_name: 'Region::Country', foreign_key: 'parent_id'
  has_many :cities, class_name: 'Region::City', foreign_key: 'parent_id'
end
