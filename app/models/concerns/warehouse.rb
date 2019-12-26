module Warehouse
  extend ActiveSupport::Concern

  def self.table_name_prefix
    'warehouse_'
  end
end