class Region::Base < ApplicationRecord
  self.table_name = 'regions'
  translates :name

  validates :tencent_id, :baidu_id, uniqueness: true, allow_blank: true
  validates :name, presence: true
end
